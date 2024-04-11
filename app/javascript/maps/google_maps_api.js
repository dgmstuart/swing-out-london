export class GoogleMapsApi {
  constructor({ apiKey }) {
    this.apiKey = apiKey;
  }

  isLoaded() {
    window.google && window.google.maps
  }

  load(callback) {
    const callbackName = "afterGoogleMapLoaded"
    window[callbackName] = callback
    const script = this._googleMapsScriptTag(callbackName)
    document.head.appendChild(script)
  }

  _googleMapsScriptTag(callbackName) {
    const script = document.createElement('script');
    script.async = true;
    script.defer = true;
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKey}&callback=${callbackName}`;
    return script
  }
}
