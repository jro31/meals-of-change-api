module Api
  module V1
    class RecipesController < Api::V1::BaseController

      # GET /api/v1/recipes
      def index
        # TODO

        # Include pagination (see rails-nile)
        # Must be filterable by tag,
        # search query (searching recipe name, ingredient food and tag name)
        # and user

        # Don't return recipes that don't have at least one ingredient, and one step
        # Prioritise recipes with photos?
      end

      # GET /api/v1/recipes/:id
      def show
        begin
          recipe = Recipe.find(params[:id])
          authorize recipe

          render json: {
            recipe: RecipeRepresenter.new(recipe).as_json
          }, status: :ok
        rescue => e
          skip_after_action :verify_authorized
          render json: {
            error_message: e.message
          }, status: :not_found
        end
      end

      # POST /api/v1/recipes
      def create
        begin
          @recipe = Recipe.new(recipe_params)
          authorize @recipe

          attach_photo
          set_user
          find_or_create_tags

          @recipe.save!

          render json: {
            recipe: RecipeRepresenter.new(@recipe).as_json
          }, status: :created
        rescue Pundit::NotAuthorizedError
          render json: {
            error_message: 'User must be signed-in to create a recipe'
          }, status: :unauthorized
        rescue => e
          puts e.inspect
          render json: {
            error_message: e.message
          }, status: :unprocessable_entity
        end
      end

      private

      def recipe_params
        params.require(:recipe).permit(:name, :time_minutes, :preface, ingredients_attributes: [
          :amount, :food, :preparation, :optional
        ], steps_attributes: [
          :position, :instructions
        ])
      end

      def attach_photo
        @recipe.photo.attach(params[:recipe][:photo_blob_signed_id]) if params[:recipe][:photo_blob_signed_id].present?
      end

      def set_user
        @recipe.user = current_user
      end

      def find_or_create_tags
        return unless params[:recipe][:tags].reject(&:blank?).any?

        @recipe.tags << params[:recipe][:tags].reject(&:blank?).map{ |tag_name| Tag.find_or_initialize_by(name: tag_name.downcase) }
      end
    end
  end
end
