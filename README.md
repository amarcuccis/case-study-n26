# N26 SFDC Customer Info Module

## Customer Info Card LWC for Case Layout

**API Name:** [contactProductInfo](./force-app/main/default/lwc/contactProductInfo/)

LWC that allows to show Product Information about the Contact on the Case Layout, based on the selected Product Type and Home Country of the contact.

**Examples:**

- **Product:** Standard
- **Country:** Spain

<img width="491" alt="Screenshot 2023-01-11 at 16 29 31" src="https://user-images.githubusercontent.com/7550201/212051043-47bc43ca-03b6-42ea-904d-cb280220da3b.png">


- **Product:** Black
- **Country:** Spain

<img width="492" alt="Screenshot 2023-01-11 at 16 29 49" src="https://user-images.githubusercontent.com/7550201/212050922-a1a47545-9921-4017-8acb-20ec1f6c056c.png">


- **Product:** Metal
- **Country:** Spain

<img width="493" alt="Screenshot 2023-01-11 at 16 29 19" src="https://user-images.githubusercontent.com/7550201/212051021-1e0a013c-c2e5-48e3-b9e1-b2b1fc3d761a.png">


- **Product:** Black
- **Country:** Germany

<img width="487" alt="Screenshot 2023-01-11 at 16 55 40" src="https://user-images.githubusercontent.com/7550201/212051102-74621589-3f58-4a9e-b13e-f3d91582a51e.png">


- No Country or Product Selected, or no active matching Product found

<img width="491" alt="Screenshot 2023-01-12 at 12 12 44" src="https://user-images.githubusercontent.com/7550201/212052164-50b60744-115e-45f9-95ec-bef966213dc9.png">


## N26 Customers Salesforce API

**Apex Class API Name:** [WSContacts_v1](./force-app/main/default/classes/WSContacts_v1.cls)

API that allows to get Customers and Product infromation from Salesforce passing an UUID as a parameter.

Access the [API documentation here.](https://documenter.getpostman.com/view/5367157/2s8ZDR8kt1)
