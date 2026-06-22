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

    forwarded_values {

      query_string = false

      cookies {
        forward = "none"
      }

    }

  }

  ordered_cache_behavior {

    path_pattern = "/api/*"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "PUT",
      "POST",
      "PATCH",
      "DELETE"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    target_origin_id = "backend-alb"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {

      query_string = true

      headers = ["*"]

      cookies {
        forward = "all"
      }

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
