package main

import (
	"log"
	"net/http"
	"net/url"
	"os"
)

func main() {
	http.HandleFunc("/", SAMLServer)
	log.Printf("Starting SAML listener at 127.0.0.1:35001")
	if err := http.ListenAndServe("127.0.0.1:35001", nil); err != nil {
		log.Fatal(err)
	}
}

func SAMLServer(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "POST method expected", http.StatusMethodNotAllowed)
		return
	}
	if err := r.ParseForm(); err != nil {
		http.Error(w, "Failed to parse form", http.StatusBadRequest)
		return
	}
	SAMLResponse := r.FormValue("SAMLResponse")
	if len(SAMLResponse) == 0 {
		http.Error(w, "SAMLResponse field is empty or missing", http.StatusBadRequest)
		return
	}
	if err := os.WriteFile("saml-response.txt", []byte(url.QueryEscape(SAMLResponse)), 0600); err != nil {
		log.Printf("Failed to write SAML response: %v", err)
		http.Error(w, "Internal error", http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "text/html")
	w.Write([]byte("<html><body><h2>Authentication successful!</h2><p>You can close this window.</p></body></html>"))
	log.Printf("Got SAMLResponse, saved to saml-response.txt")
}
