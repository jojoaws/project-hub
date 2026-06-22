data "aws_cloudfront_origin_request_policy" "all_viewer_except_host" {
  name = "Managed-AllViewerExceptHostHeader"
}

data "aws_cloudfront_cache_policy" "caching_disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_origin_access_control" "frontend" {

  name = "${var.project_name}-oac"

  description = "OAC for ProjectHub frontend"

  origin_access_control_origin_type = "s3"

  signing_behavior = "always"

  signing_protocol = "sigv4"

}

resource "aws_cloudfront_distribution" "frontend" {

  enabled = true

  default_root_object = "index.html"

  origin {

    domain_name = aws_s3_bucket.frontend.bucket_regional_domain_name

    origin_id = "frontend-s3"

    origin_access_control_id = aws_cloudfront_origin_access_control.frontend.id

  }

  origin {

    domain_name = aws_lb.main.dns_name

    origin_id = "backend-alb"

    custom_origin_config {

      http_port = 80

      https_port = 443

      origin_protocol_policy = "http-only"

      origin_ssl_protocols = ["TLSv1.2"]

    }

  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  default_cache_behavior {

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    target_origin_id = "frontend-s3"

    viewer_protocol_policy = "redirect-to-https"

    compress = true

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_optimized.id

  }

  ordered_cache_behavior {

    path_pattern = "/api/*"

    target_origin_id = "backend-alb"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    cache_policy_id = data.aws_cloudfront_cache_policy.caching_disabled.id

    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host.id

    function_association {

      event_type = "viewer-request"

      function_arn = aws_cloudfront_function.strip_api_prefix.arn

    }
  }

  restrictions {

    geo_restriction {

      restriction_type = "none"

    }

  }

  viewer_certificate {

    cloudfront_default_certificate = true

  }

}

resource "aws_cloudfront_function" "strip_api_prefix" {

  name = "${var.project_name}-strip-api-prefix"

  runtime = "cloudfront-js-2.0"

  comment = "Strips /api prefix from backend requests"

  publish = true

  code = <<EOF
function handler(event) {

    var request = event.request;

    if (request.uri.startsWith('/api')) {

        request.uri = request.uri.replace('/api', '');

        if (request.uri === '') {

            request.uri = '/';

        }

    }

    return request;

}
EOF

}
