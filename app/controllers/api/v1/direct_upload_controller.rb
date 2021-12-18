module Api
  module V1
    class DirectUploadController < Api::V1::BaseController
      def create
        begin
          authorize Recipe
          # TODO - Throw an error unless 'params[:content_type]' is 'jpg/jpeg/gif/png'
          # Note that this isn't entirely secure, as it'd still be possible for the content_type param to be manipulated before being passed-in
          # Can the file type be limited on AWS?

          response = generate_direct_upload(blob_params)
          render json: response
        rescue => e
          # TODO - Handle this
        end
      end

      private

      def blob_params
        params.require(:file).permit(:filename, :byte_size, :checksum, :content_type, metadata: {})
      end

      def generate_direct_upload(blob_args)
        blob = create_blob(blob_args)
        response = signed_url(blob)
        response[:blob_signed_id] = blob.signed_id
        response
      end

      def create_blob(blob_args)
        blob = ActiveStorage::Blob.create_before_direct_upload!(blob_args.to_h.deep_symbolize_keys)
        photo_id = SecureRandom.uuid
        blob.update_attribute(:key, "photos/recipes/#{params[:file][:image_size]}/#{photo_id}")
        blob
      end

      def signed_url(blob)
        expiration_time = 10.minutes
        response_signature(
          blob.service_url_for_direct_upload(expires_in: expiration_time),
          headers: blob.service_headers_for_direct_upload
        )
      end

      def response_signature(url, **params)
        {
          direct_upload: {
            url: url
          }.merge(params)
        }
      end
    end
  end
end
