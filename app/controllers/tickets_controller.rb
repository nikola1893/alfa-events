class TicketsController < ApplicationController
  before_action :authenticate_user!, except: [:enter]

  def index
    @tickets = Ticket.all.reverse
  end

  def show
    @ticket = Ticket.find_by(token: params[:token])
    qrcode = RQRCode::QRCode.new("https://alfa-events-bafea2c349ed.herokuapp.com/tickets/#{@ticket.token}/enter")
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 12,
      standalone: true,
      use_path: true
    )
  end

  def enter
    @ticket = Ticket.find_by(token: params[:token])
    
    if current_user.present?
      if @ticket.vazecka == true
        @ticket.update!(vazecka: false)
        flash[:notice] = "Valid! Welcome to the event!"
      # Optionally, you can redirect to another page after updating the status
      else
        flash[:alert] = "Invalid! This ticket has already been used."
      end
      redirect_to ticket_path(@ticket.token)
    else
      redirect_to "https://alfaeventsteam.wixsite.com/alfaevents", allow_other_host: true
    end
  end

end
