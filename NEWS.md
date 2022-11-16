# Sentry 0.4.0

* Needed to use jsonlite::unbox() to ensure that length one vectors are written as scalars rather than arrays in the JSON output.

# Sentry 0.3.0

* Added summary information to output to facilitate sending summary emails about an ALS deliverable.
    + Two primary components "data" and "validation summary".
        + "data" will provide the validated data when the validation is successful (i.e., status = "pass"). No data are provided if any validation checks fail (i.e., status = "fail").
        + "validation summary" provides an indication if the data passed or failed validation, the HTML validation report, key value pair information for relating the validation report to the "lab_sdg" in this case, and information for constructing an email.
key_value_pair_element: This is a string indicating the name of the JSON element that should be used to form a key-value-pair. I went with this structure because it should provide us with a standard "validation_summary" structure that can accommodate changes to the key-value-pair for other data sets (e.g., WAVE, bug data, etc.). For example, "lab_sdg" would be the appropriate element to link the report to a data deliverable from ALS, but it would not be the appropriate element to link a report to WAVE data.
key_value_pair_value: This is the actual value that should be used to represent the ke-value-pair.
status: If any validation checks fail, then this will represent "fail." If all validation checks pass, then this will represent "pass."
email_address: indicates the email address(es) tje validation summary should be emailed to. At a minimum, a single email address will be provided. However, I think it would be advantages to allow this field to represent an array of email address.
email_subject: A string to be used as the email subject.
email_body: Am HTML formatted string to be used as the body of the email.
email_attachment: any attachments to be included in the email.
report: an HTML report summarizing the validation procedures performed.
raw_data: used to indicate if the raw data should be included as an email attachment (raw_data = true) or not (raw_data = false). The value is determined by "status." If status = "pass", then raw_data = false.  If status = "fail", then raw_data = true.  Therefore, raw data are only included in as an attachment if the validation fails. The reasoning behind this is if there is a validation failure, the attached HTML validation report will give the data analyst information about where the failure(s) occurred but the next thing the analyst will want is access to the raw data to 1) correct the issue or 2) further explore the issue. 
Is this too much to ask for? 
Is there a better alternative? Maybe the email could point to a location of where the raw data can be accessed?

# Sentry 0.2.0

* Stopped using `serializeJSON()` because it was adding forward slashes as separation characters in the JSON file. This was leading to errors on ITS's end.

# Sentry 0.1.0

* Added __kableExtra__ as a dependency. ITS identified error caused by the absence of this dependency.

# Sentry 0.0.1

# sentry 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
