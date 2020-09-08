terraform {
  required_version = "0.13.1"
}

module "my_website" {
  source = "./my-website-bucket"

  name = "env0.my-website.cd.blog.com"
  html_file_source = "index.html"
}

output "my_website_endpoint" {
  value = module.my_website.website_endpoint
}
