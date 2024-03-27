class Ticket < ApplicationRecord
  belongs_to :user

  private

  def self.print_qr_codes
    desktop_folder_path = File.expand_path("~/Desktop/alfa-tickets")
    last(10).each_with_index do |ticket, i|
      qrcode = RQRCode::QRCode.new("https://alfa-events-bafea2c349ed.herokuapp.com/tickets/#{ticket.token}/enter")
      qr = qrcode.as_png(
        color: "000",
        shape_rendering: "crispEdges",
        module_size: 5,
        standalone: true,
        use_path: true,
        offset: 4
      )

      ticket_image = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/ticket-design.png")
      qr_image = ChunkyPNG::Image.from_blob(qr.to_s)
      a = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/a.png")
      b = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/b.png")
      c = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/c.png")
      d = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/d.png")
      e = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/e.png")
      f = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/f.png")
      g = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/g.png")
      h = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/h.png")
      i = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/i.png")
      j = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/j.png")
      k = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/k.png")
      l = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/l.png")
      m = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/m.png")
      n = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/n.png")
      o = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/o.png")
      p = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/p.png")
      q = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/q.png")
      r = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/r.png")
      s = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/s.png")
      t = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/t.png")
      u = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/u.png")
      v = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/v.png")
      w = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/w.png")
      x = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/x.png")
      y = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/y.png")
      z = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/z.png")
      zero = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/0.png")
      one = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/1.png")
      two = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/2.png")
      three = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/3.png")
      four = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/4.png")
      five = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/5.png")
      six = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/6.png")
      seven = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/7.png")
      eight = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/8.png")
      nine = ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/9.png")

      y_offset = (ticket_image.height - qr_image.height) / 1.25

      ticket_image.compose!(qr_image, 675, y_offset)

      # Load PNG images for each character
      token_images = []
      ticket.token.each_char do |char|
        token_images << ChunkyPNG::Image.from_file("#{desktop_folder_path}/assets/#{char.downcase}.png")
      end

      # Compose token images onto ticket image
      x_offset = 1575

      token_images.each do |char_image|
        ticket_image.compose!(char_image, x_offset, 40)
        x_offset += char_image.width - 1 # Adjust for spacing between characters
      end
  
      ticket_image.save("#{desktop_folder_path}/tickets/#{ticket.token}.png", :fast_rgba)
      
    end
    puts "🎉 Done"
  end
  
end
