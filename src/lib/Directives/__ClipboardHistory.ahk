#Requires AutoHotkey v2+
/**
 * @author teadrinker
 * @source v1 : https://www.autohotkey.com/boards/viewtopic.php?t=114540
 * @source v2 : https://www.autohotkey.com/boards/viewtopic.php?f=83&t=115682
 */

if !ClipboardHistory.HistoryEnabled {
    if MsgBox('Clipboard history disabled, want to enable?', 'Clipboard History', 'YN') = 'No'
        ExitApp()
    ClipboardHistory.HistoryEnabled := true
}
MsgBox('Clipboard history enabled')
MsgBox(ClipboardHistory.GetHistoryItemText(1), 'First item text')
MsgBox(ClipboardHistory.DeleteHistoryItem(1), 'Boolean success status')    ; deletes the first history item and returns boolean success status
MsgBox(ClipboardHistory.GetHistoryItemText(1), 'First item text')
MsgBox(ClipboardHistory.PutHistoryItemIntoClipboard(2), 'Success status') ; puts the second history item into Clipboard and returns succsess status
MsgBox(A_Clipboard, 'Clipboard content')

formats := ''
for fmt in ClipboardHistory.GetAvailableFormats(2) { ; available formats of the second history item
    formats .= fmt . '`n'
}
MsgBox(formats, 'Available Formats')

historyItemCount := ClipboardHistory.Count
Loop historyItemCount {
    MsgBox(ClipboardHistory.GetHistoryItemText(A_Index), 'Item ' . A_Index . ' of ' . historyItemCount, 'T.7')
}

class ClipboardHistory
{
; properties
    static HistoryEnabled {
        get => CBH_API.HistoryEnabled
        set => CBH_API.HistoryEnabled := value ; boolean
    }
    static Count => CBH_API.GetClipboardHistoryItems()

; methods
    static ClearHistory()                     => CBH_API.ClearHistory()
    static DeleteHistoryItem(index)           => CBH_API.DeleteHistoryItem(index) ; 1 based index
    static GetHistoryItemText(index)          => CBH_API.GetHistoryItemText(index)
    static PutHistoryItemIntoClipboard(index) => CBH_API.PutHistoryItemIntoClipboard(index)
    static GetAvailableFormats(index)         => CBH_API.GetAvailableFormats(index)
}

class CBH_API
{
    /*
        https://is.gd/bYyogJ     Clipboard Class (MSDN)
        https://is.gd/2z2Y9G     Windows.ApplicationModel.DataTransfer.0.h (GitHub)
        https://is.gd/T4Lb7b     asyncinfo.h (GitHub)
    */
    static HistoryEnabled {
        get => IClipboardStatics2.IsHistoryEnabled
        set => RegWrite(!!value, 'REG_DWORD', 'HKCU\SOFTWARE\Microsoft\Clipboard', 'EnableClipboardHistory')
    }

    static ClearHistory() => IClipboardStatics2.ClearHistory()

    static DeleteHistoryItem(index) { ; 1 based
        if !pIClipboardHistoryItem := this.GetClipboardHistoryItemByIndex(index)
            return false
        bool := IClipboardStatics2.DeleteItemFromHistory(pIClipboardHistoryItem)
        ObjRelease(pIClipboardHistoryItem)
        return bool
    }

    static GetHistoryItemText(index) {
        if !DataPackageView := this.GetDataPackageView(index)
            return
        ReadOnlyList := IReadOnlyList(DataPackageView.AvailableFormats)
        textFound := false
        Loop ReadOnlyList.Count
            HSTRING := ReadOnlyList.Item[A_Index - 1]
        until WrtString(HSTRING).GetText() = 'Text' && textFound := true
        if !textFound
            return
        HSTRING := this.Await(DataPackageView.GetTextAsync())
        return WrtString(HSTRING).GetText()
    }

    static GetAvailableFormats(index) {
        if !DataPackageView := this.GetDataPackageView(index)
            return
        ReadOnlyList := IReadOnlyList(DataPackageView.AvailableFormats)
        AvailableFormats := []
        Loop ReadOnlyList.Count {
            HSTRING := ReadOnlyList.Item[A_Index - 1]
            AvailableFormats.Push(WrtString(HSTRING).GetText())
        }
        return AvailableFormats
    }

    static GetDataPackageView(index) {
        if !pIClipboardHistoryItem := this.GetClipboardHistoryItemByIndex(index)
            return
        pIDataPackageView := IClipboardHistoryItem(pIClipboardHistoryItem).Content
        return IDataPackageView(pIDataPackageView)
    }

    static PutHistoryItemIntoClipboard(index) {
        static SetHistoryItemAsContentStatus := ['Success', 'AccessDenied', 'ItemDeleted']
        if !pIClipboardHistoryItem := this.GetClipboardHistoryItemByIndex(index)
            return
        status := IClipboardStatics2.SetHistoryItemAsContent(pIClipboardHistoryItem)
        ObjRelease(pIClipboardHistoryItem)
        return SetHistoryItemAsContentStatus[status + 1]
    }

    static GetClipboardHistoryItemByIndex(index) { ; 1 based
        count := this.GetClipboardHistoryItems(&ReadOnlyList)
        if (count < index) {
            MsgBox('Index "' . index . '" exceeds items count!')
            return
        }
        return pIClipboardHistoryItem := ReadOnlyList.Item[index - 1]
    }

    static GetClipboardHistoryItems(&ReadOnlyList := '') {
        pIClipboardHistoryItemsResult := this.Await(IClipboardStatics2.GetHistoryItemsAsync())
        ClipboardHistoryItemsResult := IClipboardHistoryItemsResult(pIClipboardHistoryItemsResult)
        pIReadOnlyList := ClipboardHistoryItemsResult.Items
        ReadOnlyList := IReadOnlyList(pIReadOnlyList)
        return ReadOnlyList.Count
    }

    static Await(pIAsyncOperation) {
        static AsyncStatus := ['Started', 'Completed', 'Canceled', 'Error']
        AsyncOperation := IAsyncOperation(pIAsyncOperation)
        pIAsyncInfo := AsyncOperation.QueryIAsyncInfo()
        AsyncInfo := IAsyncInfo(pIAsyncInfo)
        Loop {
            Sleep(10)
            status := AsyncStatus[AsyncInfo.Status + 1]
        } until status != 'Started'
        if (status != 'Completed')
            throw OSError('AsyncInfo error, status: "' . status . '"', A_ThisFunc)
        return AsyncOperation.GetResults()
    }
}

class IClipboardStatics2 {
    static __New() {
        static IID_IClipboardStatics2 := '{D2AC1B6A-D29F-554B-B303-F0452345FE02}', VT_UNKNOWN := 0xD
        if !(A_OSVersion ~= '^10\.')
            throw OSError('This class requires Windows 10 or later!', A_ThisFunc)
        
        WrtStr := WrtString('Windows.ApplicationModel.DataTransfer.Clipboard')
        DllCall('Ole32\CLSIDFromString', 'Str', IID_IClipboardStatics2, 'Ptr', CLSID := Buffer(16))
        this.comObj := ComValue(VT_UNKNOWN, WrtStr.GetFactory(CLSID))
        this.ptr := this.comObj.ptr
    }
    static GetHistoryItemsAsync() => (ComCall(6, this, 'UIntP', &pIAsyncOperation := 0), pIAsyncOperation)

    static ClearHistory() => (ComCall(7, this, 'UIntP', &res := 0), res)

    static DeleteItemFromHistory(pIClipboardHistoryItem) => (ComCall(8, this, 'Ptr', pIClipboardHistoryItem, 'UIntP', &res := 0), res)

    static SetHistoryItemAsContent(pIClipboardHistoryItem) => (ComCall(9, this, 'Ptr', pIClipboardHistoryItem, 'UIntP', &res := 0), res)

    static IsHistoryEnabled => (ComCall(10, this, 'UIntP', &res := 0), res)
}

class IClipboardHistoryItemsResult extends _InterfaceBase
{
    Items => (ComCall(7, this, 'PtrP', &pIReadOnlyList := 0), pIReadOnlyList)
}

class IClipboardHistoryItem extends _InterfaceBase
{
    Content => (ComCall(8, this, 'PtrP', &pIDataPackageView := 0), pIDataPackageView)
}

class IDataPackageView extends _InterfaceBase
{
    AvailableFormats => (ComCall(9, this, 'PtrP', &pIReadOnlyList := 0), pIReadOnlyList)

    GetTextAsync() => (ComCall(12, this, 'UIntP', &pIAsyncOperation := 0), pIAsyncOperation)
}

class IReadOnlyList extends _InterfaceBase
{
    Item[index] => (ComCall(6, this, 'Int', index, 'PtrP', &pItem := 0), pItem)

    Count => (ComCall(7, this, 'UIntP', &count := 0), count)
}

class IAsyncOperation extends _InterfaceBase
{
    QueryIAsyncInfo() => ComObjQuery(this, IID_IAsyncInfo := '{00000036-0000-0000-C000-000000000046}')

    GetResults() => (ComCall(8, this, 'PtrP', &pResult := 0), pResult)
}

class IAsyncInfo extends _InterfaceBase
{
    Status => (ComCall(7, this, 'PtrP', &status := 0), status)
}

class _InterfaceBase
{
    __New(ptr) {
        this.comObj := ComValue(VT_UNKNOWN := 0xD, ptr)
        this.ptr := this.comObj.ptr
    }
}

class WrtString
{
    __New(stringOrHandle) {
        if Type(stringOrHandle) = 'Integer'
            this.ptr := stringOrHandle
        else {
            DllCall('Combase\WindowsCreateString', 'WStr', stringOrHandle, 'UInt', StrLen(stringOrHandle), 'PtrP', &HSTRING := 0)
            this.ptr := HSTRING
        }
    }
    __Delete() {
        DllCall('Combase\WindowsDeleteString', 'Ptr', this)
    }
    GetText() {
        buf := DllCall('Combase\WindowsGetStringRawBuffer', 'Ptr', this, 'UIntP', &len := 0, 'Ptr')
        return StrGet(buf, len, 'UTF-16')
    }
    GetFactory(riid) {
        hr := DllCall('Combase\RoGetActivationFactory', 'Ptr', this, 'Ptr', riid, 'PtrP', &pInterface := 0)
        if (hr != 0)
            throw OSError(WrtString.SysError(hr), A_ThisFunc)
        return pInterface
    }
    static SysError(nError := '') {
        static flags := (FORMAT_MESSAGE_ALLOCATE_BUFFER := 0x100) | (FORMAT_MESSAGE_FROM_SYSTEM := 0x1000)
        (nError = '' && nError := A_LastError)
        DllCall('FormatMessage', 'UInt', flags, 'UInt', 0, 'UInt', nError, 'UInt', 0, 'PtrP', &pBuf := 0, 'UInt', 128)
        err := (str := StrGet(pBuf)) = '' ? nError : str
        DllCall('LocalFree', 'Ptr', pBuf)
        return err
    }
}