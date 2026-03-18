#!/usr/bin/env python3
"""Minimal SAML response listener for AWS VPN Client SSO authentication."""
import http.server
import urllib.parse
import sys

class SAMLHandler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length).decode()
        params = urllib.parse.parse_qs(body)
        saml = params.get("SAMLResponse", [None])[0]
        if not saml:
            self.send_error(400, "SAMLResponse field is empty or missing")
            return
        with open("saml-response.txt", "w") as f:
            f.write(urllib.parse.quote(saml, safe=""))
        self.send_response(200)
        self.send_header("Content-Type", "text/html")
        self.end_headers()
        self.wfile.write(b"<html><body><h2>Authentication successful!</h2><p>You can close this window.</p></body></html>")
        print("Got SAMLResponse, saved to saml-response.txt")

    def log_message(self, format, *args):
        print(format % args)

if __name__ == "__main__":
    server = http.server.HTTPServer(("127.0.0.1", 35001), SAMLHandler)
    print("Starting SAML listener at 127.0.0.1:35001")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
