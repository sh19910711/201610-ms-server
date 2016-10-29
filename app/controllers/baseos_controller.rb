class BaseosController < ApplicationController
  before_action :auth_device

  def heartbeat
    @device.update_hearbeat(heartbeat_params[:status], request.raw_post)
    deployment = @device.get_deployment!
    render body: (deployment ? deployment.id.to_s : 'X')
  end

  def image
    deployment = @device.get_deployment!(image_params[:deployment_id])

    # Devices that does not have enough memory downloads an image partially using Range.
    handle_range_header(deployment.image)
  end

  def envvars
    body = @device.envvars_index.inject("") {|b, v| b += "#{v.name}=#{v.value}\x04" }
    render status: :ok, body: body
  end

  private

  def handle_range_header(data)
    partial = false # send whole data by default
    if request.headers["Range"]
      if /bytes=(?<offset>\d+)-(?<offset_end>\d*)/ =~ request.headers['Range']
        partial = true
        offset = offset.to_i
        offset_end =  (offset_end == "") ? data.size : offset_end.to_i
        length = offset_end - offset + 1

        if offset < 0 || length < 0
          return head :bad_request
        end
      else
        return head :bad_request
      end
    end

    if partial
      response.header['Content-Length'] = "#{length}"
      response.header['Content-Range']  = "bytes #{offset}-#{offset_end}/#{data.size}"
      send_data data[offset, length], status: :partial_content, disposition: "inline"
    else
      send_data data, status: :ok
    end
  end

  def auth_device
    @device = Device.find_by_device_secret(params[:device_secret])
    unless @device
      head :forbidden
      return false
    end
  end

  def heartbeat_params
    params.permit(:device_secret, :status)
  end

  def image_params
    params.permit(:device_secret, :deployment_id)
  end
end
