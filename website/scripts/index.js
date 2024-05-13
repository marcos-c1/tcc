const sections = document.querySelectorAll('section')
const sidebar = document.querySelectorAll('.side-list > li')
const sublist = document.querySelectorAll('.side-list > ul > li')
const arrow = document.getElementById('arrow')
const menu = document.getElementById('menu')

const container = document.getElementById('primary-container')
const nav = document.getElementById('nav-page')
const submenu = document.getElementById('links')

window.addEventListener('resize', () => {
  if(window.innerWidth >= 651){
    submenu.style.display = 'block'
    container.style.gridTemplateColumns = '30% 70%'
  } else {
    submenu.style.display = 'none'
    container.style.gridTemplateColumns = '10% 90%'
  }
})
menu.addEventListener('click', (_)=> {
  if(!submenu.style.display || submenu.style.display == 'none'){
    menu.style.alignContent = 'start'
    submenu.style.display = 'block'
    container.style.gridTemplateColumns = '40% 60%'
  } else {
    menu.style.alignContent = 'center'
    submenu.style.display = 'none'
    container.style.gridTemplateColumns = '10% 90%'
  }
})

sublist.forEach(li => {
    li.addEventListener('click', (ev) => {
        const identifier = parseInt(ev.target.innerText[0])
        parseIdentifier(identifier)
    })
})

arrow.addEventListener('click', () => {
    document.querySelector('html').scroll({ top: 0, behavior: 'smooth' });
});

function parseIdentifier(identifier) {
    let intro = document.querySelector('#intro')
    let meth = document.querySelector('#methodology')
    let cr = document.querySelector('#code-review')
    let ev = document.querySelector('#evaluation')

    switch (identifier) {
        case 1:
            intro.removeAttribute('hidden')
            if (!meth.hasAttribute('hidden')) meth.toggleAttribute('hidden', true)
            if (!ev.hasAttribute('hidden')) ev.toggleAttribute('hidden', true)
            if (!cr.hasAttribute('hidden')) cr.toggleAttribute('hidden', true)
            break;
        case 2:
            meth.removeAttribute('hidden')
            if (!intro.hasAttribute('hidden')) intro.toggleAttribute('hidden', true)
            if (!ev.hasAttribute('hidden')) ev.toggleAttribute('hidden', true)
            if (!cr.hasAttribute('hidden')) cr.toggleAttribute('hidden', true)
            break;
        case 3:
            cr.removeAttribute('hidden')
            if (!intro.hasAttribute('hidden')) intro.toggleAttribute('hidden', true)
            if (!meth.hasAttribute('hidden')) meth.toggleAttribute('hidden', true)
            if (!ev.hasAttribute('hidden')) ev.toggleAttribute('hidden', true)
            break;
        case 4:
            ev.removeAttribute('hidden')
            if (!intro.hasAttribute('hidden')) intro.toggleAttribute('hidden', true)
            if (!meth.hasAttribute('hidden')) meth.toggleAttribute('hidden', true)
            if (!cr.hasAttribute('hidden')) cr.toggleAttribute('hidden', true)
            break;
        default:
            console.error('Could not parse identifier correctly.')
            break;
    }
}

for (let i = 0; i < sidebar.length; i++) {
    sidebar[i].addEventListener('click', (event) => {
        const active = document.querySelector('.active')
        const identifier = parseInt(event.target.ariaLabel)

        active.classList.remove('active')

        if (!event.target.classList.contains('active')) {
            event.target.classList.add('active')
        }

        parseIdentifier(identifier)
    })
}
