//
//  Constants.swift
//  GogoEat
//
//  Created by Apple on 11/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

let DeviceType_Android = "1"
let DeviceType_iOS = "2"
let DeviceType_Web = "3"
    
let APIKEY = "G0G0e@t$"
let ACCESSTOKENKEY = "access_token"

let Server = "https://api.tapatradie.com/"
//let Server = "http://3.109.98.222:3349/"
let BaseUrl = "\(Server)v6/api/"



/*
Old servers
//let Server = "http://www.tapatradie.net.au:3346/"
//let Server = "http://18.224.173.178:3346/"
*/

let Server1 = Server


let url_iap_termsandconditions = url_termsandconditions;
let url_iap_privacypolicy = url_privacypolicy;

let url_termsandconditions = "\(Server)termsandconditions";
let url_privacypolicy = "\(Server)privacypolicy";
let url_aboutus = "\(Server)aboutus";



let api_get_free_date = "\(BaseUrl)get-free-date"

let api_generate_access_token = "\(BaseUrl)genrate-access-tokan"
let api_provider_otp_registration = "\(BaseUrl)user-otp-registration"
let api_provider_verify_otp = "\(BaseUrl)user-verify-otp"
let api_resent_otp = "\(BaseUrl)resent-otp"
//let api_provider_register_step2 = "\(BaseUrl)provider-register-step2"
let api_provider_register_step2 = "\(BaseUrl)provider-register-step2-new"
let api_provider_get_address = "\(BaseUrl)provider-get-address"
let api_get_services_list = "\(BaseUrl)get-services-list"
let api_provider_tradie_search = "\(BaseUrl)provider-tradie-search"
let api_provider_job_request_to_tradie = "\(BaseUrl)provider-job-request-to-tradie"
let api_provider_add_address = "\(BaseUrl)provider-add-address"
let api_get_provider_profile = "\(BaseUrl)get-provider-profile"
let api_provider_leads = "\(BaseUrl)provider-leads"
let upload_file_for_chat = "\(BaseUrl)upload-file-for-chat"
let api_provider_update_profile = "\(BaseUrl)provider-update-profile"
let api_upload_profile_picture = "\(BaseUrl)upload-profile-picture"
let api_provider_job_action = "\(BaseUrl)provider-job-action"
let api_provider_job_action_new = "\(BaseUrl)provider-job-action-new"
let api_provider_raise_dispute = "\(BaseUrl)provider-raise-dispute"
let api_provider_give_review = "\(BaseUrl)provider-give-review"
let api_provider_assign_service_to_him = "\(BaseUrl)provider-assign-service-to-him"
//let api_provider_register_step2 = "\(BaseUrl)provider-register-step2"
let api_provider_profile_steps = "\(BaseUrl)provider-profile-steps"
let api_provider_identify_verification_update = "\(BaseUrl)provider-identify-verification-update"
let api_get_country_list = "\(BaseUrl)get-country-list"
let api_provider_business_detail_update = "\(BaseUrl)provider-business-detail-update"
let api_provider_get_business_detail = "\(BaseUrl)provider-get-business-detail"
let api_provider_upload_image = "\(BaseUrl)provider-upload-image"
let api_provider_gallery_image_list = "\(BaseUrl)provider-gallery-image-list"
let api_provider_delete_image = "\(BaseUrl)provider-delete-image"
//let api_provider_leads = "\(BaseUrl)provider-leads"
//let api_provider_job_action = "\(BaseUrl)provider-job-action"
//let api_provider_add_address = "\(BaseUrl)provider-add-address"
//let api_provider_get_address = "\(BaseUrl)provider-get-address"

let api_tradie_online_address = "\(BaseUrl)tradie-online-address"

let api_provider_online_status = "\(BaseUrl)provider-online-status"
let api_provider_get_review_list = "\(BaseUrl)provider-get-review-list"
let api_logout = "\(BaseUrl)Logout"
let api_submit_for_approval = "\(BaseUrl)submit-for-approval"

let api_delete_history = "\(BaseUrl)delete-history"


let api_save_purchase_history = "\(BaseUrl)save-purchase-history"

let api_save_purchase_history_file = "\(BaseUrl)save-purchase-history-file"

let api_new_save_subscription_data = "\(BaseUrl)new-save-subscription-data"

let api_user_facebook_login = "\(BaseUrl)user-facebook-login"

let api_get_notification_list = "\(BaseUrl)get-notification-list"

let clear_notification = "\(BaseUrl)clear-notification"
 
let api_delete_notification = "\(BaseUrl)delete-notification"

let api_read_notification = "\(BaseUrl)read-notification"

let api_get_versions = "\(BaseUrl)get-versions"

let api_get_unread_notification_count = "\(BaseUrl)get-unread-notification-count"

let api_read_badge_notification = "\(BaseUrl)read-badge-notification"

let api_ios_purchase_membership = "\(BaseUrl)ios-purchase-membership"

let api_get_current_subscription = "\(BaseUrl)get-current-subscription"
let api_cancel_current_subscription = "\(BaseUrl)cancel-subscription"

//MARK: Payment API
let get_subscription_list = "\(BaseUrl)get-subscription-list"

let create_card_token = "\(BaseUrl)create-card-token"
let subscription_payment = "\(BaseUrl)subscription-payment"
let deleteAccount = "\(BaseUrl)deleteAccount"

let api_get_category_list = "\(BaseUrl)supportcategory"
let api_get_support_enquiry = "\(BaseUrl)supportEnquery"

let api_sync_GoogleRating = "\(BaseUrl)syncGooglerating"
let api_show_socialRating = "\(BaseUrl)showSocialRating"
let notificationsetting = "\(BaseUrl)notificationsetting"

class Constants: NSObject {
    
}
