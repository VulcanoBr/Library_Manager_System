import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="telephones"
export default class extends Controller {
  static targets = ['container', 'template']

  connect() {
    this.templateContent = this.templateTarget.innerHTML
  }

  addTelephone(event) {
    event.preventDefault()

    const template = document.createElement('div')
    template.innerHTML = this.templateContent
    this.containerTarget.appendChild(template)

    // Limpar os campos clonados
    template.querySelectorAll('input').forEach(input => {
      input.value = ''
    })
  }

  removeTelephone(event) {
    event.preventDefault()

    const telephoneContainer = event.currentTarget.closest(
      "[data-telephones-target='phoneContainer']"
    )
    if (telephoneContainer) {
      telephoneContainer.remove()
    } else {
      const item = event.target.closest('.nested-fields')
      item.querySelector("input[name*='_destroy']").value = 1
      item.style.display = 'none'
    }
  }
}
