package main

import (
	"fmt"
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
		fmt.Fprintf(w, "Error: POST method expected, %s received", r.Method)
		return
	}
	if err := r.ParseForm(); err != nil {
		fmt.Fprintf(w, "ParseForm() err: %v", err)
		return
	}
	SAMLResponse := r.FormValue("SAMLResponse")
	if len(SAMLResponse) == 0 {
		log.Printf("SAMLResponse field is empty or missing")
		return
	}
	if err := os.WriteFile("saml-response.txt", []byte(url.QueryEscape(SAMLResponse)), 0600); err != nil {
		log.Printf("Failed to write SAML response: %v", err)
		return
	}
	fmt.Fprintf(w, "<html><body><h2>Authentication successful!</h2><p>You can close this window.</p></body></html>")
	log.Printf("Got SAMLResponse, saved to saml-response.txt")
}
