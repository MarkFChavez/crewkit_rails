import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { url: String }

  connect() {
    this.timeout = null
    this.abortController = null
  }

  disconnect() {
    this.clearTimeout()
    this.abortRequest()
  }

  search() {
    this.clearTimeout()
    this.abortRequest()

    const query = this.inputTarget.value.trim()

    if (query.length < 2) {
      this.hideResults()
      return
    }

    // Debounce search requests
    this.timeout = setTimeout(() => {
      this.performSearch(query)
    }, 300)
  }

  async performSearch(query) {
    this.abortController = new AbortController()

    try {
      const url = `${this.urlValue}?q=${encodeURIComponent(query)}`
      const response = await fetch(url, {
        signal: this.abortController.signal,
        headers: {
          'Accept': 'application/json'
        }
      })

      if (!response.ok) throw new Error('Search failed')

      const data = await response.json()
      this.displayResults(data.results)
    } catch (error) {
      if (error.name !== 'AbortError') {
        console.error('Search error:', error)
        this.hideResults()
      }
    }
  }

  displayResults(results) {
    if (results.length === 0) {
      this.resultsTarget.innerHTML = `
        <div class="px-4 py-3 text-sm text-gray-500">
          No employees found
        </div>
      `
      this.showResults()
      return
    }

    const resultsHTML = results.map(result => `
      <a href="/teams/${result.team_id}"
         class="block px-4 py-3 hover:bg-emerald-50 transition-colors border-b border-gray-100 last:border-0"
         data-action="click->search#selectResult">
        <div class="flex items-start justify-between">
          <div class="flex-1">
            <div class="font-semibold text-gray-900">${this.escapeHtml(result.name)}</div>
            <div class="text-sm text-gray-600">${this.escapeHtml(result.role)}</div>
            ${result.email ? `<div class="text-xs text-gray-500 mt-1">${this.escapeHtml(result.email)}</div>` : ''}
          </div>
          <div class="ml-3">
            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800">
              ${this.escapeHtml(result.team_name)}
            </span>
          </div>
        </div>
      </a>
    `).join('')

    this.resultsTarget.innerHTML = resultsHTML
    this.showResults()
  }

  selectResult(event) {
    this.hideResults()
    this.inputTarget.value = ''
  }

  showResults() {
    this.resultsTarget.classList.remove('hidden')
  }

  hideResults() {
    this.resultsTarget.classList.add('hidden')
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideResults()
    }
  }

  handleEscape(event) {
    if (event.key === 'Escape') {
      this.hideResults()
      this.inputTarget.blur()
    }
  }

  clearTimeout() {
    if (this.timeout) {
      clearTimeout(this.timeout)
      this.timeout = null
    }
  }

  abortRequest() {
    if (this.abortController) {
      this.abortController.abort()
      this.abortController = null
    }
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text
    return div.innerHTML
  }
}
