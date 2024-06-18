function newFile() {
    quill.setContents(new Delta());
    quill.focus();
}

function openFile() {
    obj = chrome.webview.hostObjects.ahk;
    obj.OpenFile();
}

function saveFile() {
    obj = chrome.webview.hostObjects.ahk;
    obj.SaveFile(quill.getText());
}

function passText() {
    console.log(`We are going to pass the editor contents to AHK...
The contents are: 
${quill.getText()}`);
    obj = chrome.webview.hostObjects.ahk;
    obj.get(quill.getText());
}

function exitApp() {
    obj = chrome.webview.hostObjects.ahk;
    obj.exit();
}

function passHTML() {
    console.log(`We are going to pass the editor HTML contents to AHK...
The contents are: 
${quill.getSemanticHTML()}`);
    obj = chrome.webview.hostObjects.ahk;
    obj.getHTML(quill.getSemanticHTML());
}

function about() {
    obj = chrome.webview.hostObjects.ahk;
    obj.about();
}