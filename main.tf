resource "aws_acm_certificate" "default" {
provider = "aws.acm"
domain_name="${var.domain}"
subject_alternative_names=["*.${var.domain}"]
validation_method="DNS"
lifecycle{
create_before_destroy=true
}
}


resource "aws_route53_record" "validation" {
zone_id = "${aws_route53_zone.public_zone.zone_id}"
name = "${aws_acm_certificate.default.domain_validation_options.0.resource_record_name}"
type="${aws_acm_certificate.default.domain_validation_options.0.resource_record_type}"
records=["{aws_acm_certificate.default.domain_validation_options.0.resource_record_value}"]
ttl="300"
}

resource "aws_acm_certificate_validation" "default" {
certificate_arn="${aws_acm_certificate.default.arn}"
validation_record_fqdns=[
"${aws_route53_record.validation.fqdn}"]
}


resource "aws_cloudfront_distribution" "cdn" {
viewer_certificate {
acm_certificate_arn="${aws_acm_certificate.default.0.arn}"
}
}























