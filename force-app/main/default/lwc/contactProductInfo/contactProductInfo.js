import { LightningElement, api } from 'lwc';
import getSelectedProduct from '@salesforce/apex/ContactProductInfo.getSelectedProduct';
import card_replacement_cost from '@salesforce/label/c.card_replacement_cost';
import contact_product_info_title from '@salesforce/label/c.contact_product_info_title';
import cost_per_calendar_month from '@salesforce/label/c.cost_per_calendar_month';
import home_country from '@salesforce/label/c.home_country';
import product from '@salesforce/label/c.product';
import atm_fee_in_other_currencies from '@salesforce/label/c.atm_fee_in_other_currencies';
import no_product_found from '@salesforce/label/c.no_product_found';

export default class ContactProductInfo extends LightningElement {
    label = { 
        card_replacement_cost, contact_product_info_title, cost_per_calendar_month,
        home_country, product, atm_fee_in_other_currencies, no_product_found };
    @api recordId;

    /** Front Attributes */
    selectedProduct;
    showNoProductFoundMsg;

    connectedCallback() {
        this.getContactProduct();
    }

    getContactProduct() {
        try {
            getSelectedProduct({
                caseId: this.recordId
            })
            .then((result) => {
                if(result) {
                    result.nameClass = result.Name?.toLowerCase();
                    this.selectedProduct = result;
                } else {
                    this.showNoProductFoundMsg = true;
                }
            })
            .catch((e) => {
                this.showNoProductFoundMsg = true;
                console.error("## Error :: getSelectedProduct");
                console.error(e);
            });
        } catch(e) {
            console.error("## Error :: getContactProduct");
            console.error(e);
        }
    }
}