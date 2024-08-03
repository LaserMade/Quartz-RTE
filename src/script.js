// add tooltips on hover - not finished yet!!

const options = document.querySelectorAll('.ql-formats');
options.forEach(opt => {
    let numFonts = 0;
    let numHeaders = 0;
    opt.childNodes.forEach(child => {
        child.name = child.className.replace('ql-', '')
        const span = document.createElement('span')
        span.classList.add('tooltip')
        switch(child.name) {
            case 'bold': span.textContent = 'Bold text'
            break;
            case 'italic': span.textContent = 'Italic text'
            break;
            case 'underline': span.textContent = 'Underline text'
            break;
            case 'strike': span.textContent = 'Strikethrough text'
            break;
            case 'blockquote': span.textContent = 'Blockquote'
            break;
            case 'code-block': span.textContent = 'Code block'
            break;
            case 'list': span.textContent = 'List'
            break;
            case 'indent': span.textContent = 'Indent'
            break;
            case 'link': span.textContent = 'Link'
            break;
            case 'image': span.textContent = 'Image'
            break;
            case 'video': span.textContent = 'Video'
            break;
            case 'clean': span.textContent = 'Remove formatting'
            break;
        }
        if (child.name.includes('font')){
            span.textContent = numFonts==0 ? 'Font' : ''
            numFonts++;
        } else if (child.name.includes('header')) {
            span.textContent = numHeaders==0 ? 'Header/Size' : ''
            numHeaders++;
        } else if (child.name.includes('align')) {
            span.textContent = 'Align'
        } else if (child.name.includes('color')) {
            span.textContent = 'Font color'
        } else if (child.name.includes('background')) {
            span.textContent = 'Background color'
        }
        child.appendChild(span)
        child.addEventListener('mouseover', () => {
            if (!child.classList.toString().includes('expanded')){
                span.classList.add('active')
            }
            child.addEventListener('click', () => {
                span.classList.remove('active')
            })
        })
        child.addEventListener('mouseleave', () => {
            span.classList.remove('active')
        })
    })
}); 

const header = document.querySelector('header');
header.addEventListener('onmousedown', e => {
    e.preventDefault();
    obj = chrome.webview.hostObjects.ahk;
    obj.drag();
})

const minimizeBtn = document.getElementById('min-btn');
minimizeBtn.addEventListener('click', () => {
    obj = chrome.webview.hostObjects.ahk;
    obj.minimize();
});

const maximizeBtn = document.getElementById('max-btn');
maximizeBtn.addEventListener('click', () => {
    obj = chrome.webview.hostObjects.ahk;
    obj.maximize();
});

const closeBtn = document.getElementById('close-btn');
close.addEventListener('click', () => {
    obj = chrome.webview.hostObjects.ahk;
    obj.close();
});

//not working to prevent highlighting the menu text
/* let endTitleBar = document.querySelector('.block-input');
endTitleBar.addEventListener('click', e => {
    e.preventDefault();
}) */   

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

function saveAsHTML() {
    console.log(`We are going to pass the editor contents (in HTML) to AHK...
The contents are: 
${quill.getSemanticHTML()}`);
    obj = chrome.webview.hostObjects.ahk;
    obj.saveHTML(quill.getSemanticHTML());
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

