// You can edit this code!
// Click here and start typing.
package main

import (
	"fmt"
	"log"

	"github.com/iden3/go-schema-processor/merklize"
	"github.com/iden3/go-schema-processor/utils"
)

const (
	jsonLDContext = "ipfs://QmNyzw91rkFvM38LUoZuSF1auHZqngX2ecgH6AVfYvBzzH" // JSONLD schema for credential
	typ           = "auditorexperience"                                     // credential type
	fieldName     = "competency"                                            // field name in form of field.field2.field3 field must be present in the credential subject
	schemaJSONLD  = `{
  "@context": [
    {
      "@protected": true,
      "@version": 1.1,
      "id": "@id",
      "type": "@type",
      "auditorexperience": {
        "@context": {
          "@propagate": true,
          "@protected": true,
          "polygon-vocab": "urn:uuid:793e7904-d030-4582-a20b-a3883ee68d85#",
          "xsd": "http://www.w3.org/2001/XMLSchema#",
          "company": {
            "@id": "polygon-vocab:company",
            "@type": "xsd:string"
          },
          "competency": {
            "@id": "polygon-vocab:competency",
            "@type": "xsd:string"
          }
        },
        "@id": "urn:uuid:3e785174-1d10-4d5f-a5f8-05385810a8a5"
      }
    }
  ]
}`
)

func main() {

	// content of json ld schema

	schemaID := fmt.Sprintf("%s#%s", jsonLDContext, typ)
	querySchema := utils.CreateSchemaHash([]byte(schemaID))
	fmt.Println("schema hash")
	fmt.Println(querySchema.BigInt().String())
	path, err := merklize.NewFieldPathFromContext([]byte(schemaJSONLD), typ, fieldName)
	if err != nil {
		log.Fatal(err)
	}
	err = path.Prepend("https://www.w3.org/2018/credentials#credentialSubject")
	if err != nil {
		log.Fatal(err)
	}
	mkPath, err := path.MtEntry()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("claim path key")
	fmt.Println(mkPath.String())
}
