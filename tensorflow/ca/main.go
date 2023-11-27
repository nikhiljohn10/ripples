package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha1"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"log"
	"math/big"
	"net"
	"os"
	"time"
)

func main() {
	serialNumberLimit := new(big.Int).Lsh(big.NewInt(1), 128)

	serialNumber, err := rand.Int(rand.Reader, serialNumberLimit)
	if err != nil {
		log.Fatal("failed to generate serial number: " + err.Error())
	}

	ca := &x509.Certificate{
		SerialNumber: serialNumber,
		Subject: pkix.Name{
			Organization:  []string{"Nikz Jon"},
			Country:       []string{"IN"},
			Province:      []string{"Kerala"},
			Locality:      []string{"Thrissur"},
			StreetAddress: []string{"Kuriachira"},
			PostalCode:    []string{"680006"},
		},
		NotBefore:             time.Now(),
		NotAfter:              time.Now().AddDate(10, 0, 0),
		IsCA:                  true,
		ExtKeyUsage:           []x509.ExtKeyUsage{x509.ExtKeyUsageClientAuth, x509.ExtKeyUsageServerAuth},
		KeyUsage:              x509.KeyUsageDigitalSignature | x509.KeyUsageCertSign,
		BasicConstraintsValid: true,
	}

	caPrivKey, err := rsa.GenerateKey(rand.Reader, 4096)
	if err != nil {
		log.Fatal(err)
	}

	caBytes, err := x509.CreateCertificate(rand.Reader, ca, ca, &caPrivKey.PublicKey, caPrivKey)
	if err != nil {
		log.Fatal(err)
	}

	os.MkdirAll("cert/",0766)
	caOut, err := os.Create("cert/ca.pem")
	if err != nil {
		log.Fatalf("Failed to open ca.pem for writing: %v", err)
	}
	defer caOut.Close()

	pem.Encode(caOut, &pem.Block{
		Type:  "CERTIFICATE",
		Bytes: caBytes,
	})

	caKeyOut, err := os.OpenFile("cert/ca.key", os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0600)
	if err != nil {
		log.Fatalf("Failed to open ca.key for writing: %v", err)
	}
	defer caKeyOut.Close()

	pem.Encode(caKeyOut, &pem.Block{
		Type:  "RSA PRIVATE KEY",
		Bytes: x509.MarshalPKCS1PrivateKey(caPrivKey),
	})

	encodedpub, err := x509.MarshalPKIXPublicKey(&caPrivKey.PublicKey)
	if err != nil {
		log.Fatal(err)
	}

	pubhash := sha1.New()
	pubhash.Write(encodedpub)

	validity := time.Duration(15 * 365 * 24 * time.Hour)

	serialNumber, err = rand.Int(rand.Reader, serialNumberLimit)
	if err != nil {
		log.Fatal("failed to generate serial number: " + err.Error())
	}

	cert := &x509.Certificate{
		SerialNumber: serialNumber,
		Subject: pkix.Name{
			Organization:  []string{"N2 Home"},
			Country:       []string{"IN"},
			Province:      []string{"Kerala"},
			Locality:      []string{"Kochi"},
			StreetAddress: []string{"C1-9, VT Trine"},
			PostalCode:    []string{"682021"},
			CommonName:    "n2h.home",
		},
		IPAddresses:  []net.IP{net.IPv4(127, 0, 0, 1), net.IPv6loopback},
		NotBefore:    time.Now(),
		NotAfter:     time.Now().Add(validity),
		SubjectKeyId: pubhash.Sum(nil),
		ExtKeyUsage:  []x509.ExtKeyUsage{x509.ExtKeyUsageClientAuth, x509.ExtKeyUsageServerAuth},
		KeyUsage:     x509.KeyUsageDigitalSignature,
	}

	certPrivKey, err := rsa.GenerateKey(rand.Reader, 4096)
	if err != nil {
		log.Fatal(err)
	}

	certBytes, err := x509.CreateCertificate(rand.Reader, cert, ca, &certPrivKey.PublicKey, caPrivKey)
	if err != nil {
		log.Fatal(err)
	}

	certOut, err := os.Create("cert/cert.pem")
	if err != nil {
		log.Fatalf("Failed to open cert.pem for writing: %v", err)
	}
	defer certOut.Close()

	pem.Encode(certOut, &pem.Block{
		Type:  "CERTIFICATE",
		Bytes: certBytes,
	})

	keyOut, err := os.OpenFile("cert/key.pem", os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0600)
	if err != nil {
		log.Fatalf("Failed to open key.pem for writing: %v", err)
	}
	defer keyOut.Close()

	pem.Encode(keyOut, &pem.Block{
		Type:  "RSA PRIVATE KEY",
		Bytes: x509.MarshalPKCS1PrivateKey(certPrivKey),
	})

}