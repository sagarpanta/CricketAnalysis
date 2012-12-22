# config/initializers/pdfkit.rb
PDFKit.configure do |config|
   config.wkhtmltopdf = '/wkhtmltopdf.exe'
   config.default_options = {
     :page_size => 'Legal',
     :print_media_type => true
   }
   #config.root_url = "http://www.cricitdown.com" # Use only if your external hostname is unavailable on the server.
end