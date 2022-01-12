module Api
  module V1
    class UserRecipeBookmarksController < Api::V1::BaseController
      # POST /api/v1/user_recipe_bookmarks
      def create
        begin
          @bookmark = UserRecipeBookmark.new(user_recipe_bookmark_params)
          authorize @bookmark
          @bookmark.save!

          render json: {
            user_recipe_bookmark: UserRecipeBookmarkRepresenter.new(@bookmark).as_json
          }, status: :created
        rescue Pundit::NotAuthorizedError
          render json: {
            error_message: 'User must be signed-in to create a recipe'
          }, status: :unauthorized
        rescue => e
          render json: {
            error_message: e.message
          }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/user_recipe_bookmarks/:id
      def destroy
        # TODO
      end

      private

      def user_recipe_bookmark_params
        params.require(:user_recipe_bookmark).permit(:user_id, :recipe_id)
      end
    end
  end
end