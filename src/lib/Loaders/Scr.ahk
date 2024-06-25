;; Preload

#Include <Scr\Groups>

;; App

; #Include <Scr\App\Autohotkey>
; #Include <Scr\App\Browser>
; #Include <Scr\App\Davinci>
; #Include <Scr\App\Discord>
; #Include <Scr\App\Explorer>
; #Include <Scr\App\Spotify>
; #Include <Scr\App\Player>
; #Include <Scr\App\Screenshot>
; #Include <Scr\App\Telegram>
; #Include <Scr\App\Terminal>
; #Include <Scr\App\VK>
; #Include <Scr\App\VsCode>
; #Include <Scr\App\YouTube>
; --------------------------------------------------------------------------------
#Include <App\Autohotkey>
#Include <App\Browser>
#Include <App\Davinci>
#Include <App\Discord>
#Include <App\DS4>
#Include <App\Explorer>
#Include <App\Gimp>
#Include <App\Git>
#Include <App\OBS>
#Include <App\Player>
#Include <App\Screenshot>
; #Include <App\Shows>
#Include <App\Spotify>
#Include <App\Steam>
#Include <App\Telegram>
#Include <App\Terminal>
#Include <App\VK>
#Include <App\VPN>
#Include <App\VsCode>
#Include <App\YouTube>

;; Mouse

#Include <Scr\Mouse\Singular>
#Include <Scr\Mouse\AppActions>

;; Keys

#Include <Scr\Keys\SuspendExempt>
#Include <Scr\Keys\Symbols>
#Include <Scr\Keys\Remaps>
#Include <Scr\Keys\SndMem>
#Include <Scr\Keys\VimMode>
#Include <Scr\Keys\Numpad>
#Include <Scr\Keys\WindowManager>
#Include <Scr\Keys\Hotkeys>

;; Extra

; #Include <Scr\Runner>
#Include <Scr\Hotstrings>
#Include <Scr\GeneralKeyChorder>
#Include <Scr\Win>
#Include <Scr\Explorer>
#Include <Environment>
#Include <Paths>
#Include <Abstractions\Registers>
#Include <Tools\Info>
#Include <Tools\CleanInputBox>
#Include <Utils\Choose>

;; Includes

#Include <Includes\Links>
#Include <Includes\Notes>
; #Include <Common_OSTitles>
#Include <RecLibs\Common_Rec_Texts>

;; Postload

#Include <Scr\SoundPlayer>
#Include <Scr\PostLoad>
#Include <Misc\CountLibraries>

; --------------------------------------------------------------------------------
;; Abstractions

#Include <Abstractions\Base> ; fix: Need to validate what's in here
#Include <Abstractions\Text>
#Include <Abstractions\GetFileTimes>
#Include <Abstractions\GetPicSize>
#Include <Abstractions\MediaActions>
#Include <Abstractions\Mouse>
#Include <Abstractions\MouseSectionDefaulter>
; #Include <Abstractions\Registers> ; above
#Include <Abstractions\Script>
#Include <Abstractions\SomeLockHint>
#Include <Abstractions\Text>
#Include <Abstractions\WindowManager>
; --------------------------------------------------------------------------------
;; Converters

#Include <Converters\DateTime>
#Include <Converters\Layouts>
#Include <Converters\Number>
; --------------------------------------------------------------------------------
;; Extensions

#Include <Extensions\Array>
#Include <Extensions\Gui>
#Include <Extensions\Initializable>
#Include <Extensions\Json>
#Include <Extensions\Map>
#Include <Extensions\Sort>
#Include <Extensions\String>
; --------------------------------------------------------------------------------
;; Misc

#Include <Misc\Calculator>
#Include <Misc\CloseButActually>
#Include <Misc\CountLibraries>
#Include <Misc\EmojiSearch>
#Include <Misc\HandleUIAError>
#Include <Misc\Meditate>
#Include <Misc\Out>
#Include <Misc\RemindDate>
#Include <Misc\Simpsons>
#Include <Misc\ToggleModifier>
; --------------------------------------------------------------------------------
;; System

#Include <System\Brightness>
#Include <System\DPI>
#Include <System\Language>
#Include <System\MeasureExecutionInSeconds>
#Include <System\SoundPlayer>
#Include <System\System>
#Include <System\UIA>
#Include <System\Web>
; --------------------------------------------------------------------------------
;; Tools

#Include <Tools\CleanInputBox>
#Include <Tools\CoordInfo>
#Include <Tools\Counter>
#Include <Tools\FileSystemSearch>
#Include <Tools\Hider>
#Include <Tools\HoverScreenshot>
#Include <Tools\Info>
#Include <Tools\InternetSearch>
#Include <Tools\KeycodeGetter>
#Include <Tools\Point>
#Include <Tools\RelativeCoordInfo>
#Include <Tools\Snake>
#Include <Tools\StateBulb>
#Include <Tools\ToggleInfo>
#Include <Tools\WindowGetter>
#Include <Tools\WindowInfo>
; --------------------------------------------------------------------------------
;; Utils

#Include <Utils\Autoclicker>
#Include <Utils\CharGenerator>
#Include <Utils\Choose>
#Include <Utils\ClipSend>
#Include <Utils\Cmd>
#Include <Utils\Eval>
#Include <Utils\GetClick>
#Include <Utils\GetFilesSortedByDate>
#Include <Utils\GetInput>
#Include <Utils\GetWeather>
#Include <Utils\Hotstringer>
#Include <Utils\Image>
#Include <Utils\LangDict>
#Include <Utils\Press>
#Include <Utils\Print>
#Include <Utils\Unicode>
#Include <Utils\Wait>
#Include <Utils\Win>