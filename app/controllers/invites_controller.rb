class InvitesController < ApplicationController
    require "rqrcode"
    before_action :set_invite_url
    before_action :g_qrcode

    def index; end

    def set_invite_url
      @generated_url="#{request.base_url}/users/sign_up?promoter=#{current_user.username}"
    end

    def g_qrcode
      qrcode = RQRCode::QRCode.new(@generated_url)
      svg = qrcode.as_svg(
        color: "000",
        shape_rendering: "crispEdges",
        module_size: 11,
        standalone: true,
        use_path: true
      )
      IO.binwrite("public/qrcode/#{current_user.username}.svg", svg.to_s)
    end
end
