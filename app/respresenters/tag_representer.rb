class TagRepresenter
  def initialize(tag)
    @tag = tag
  end

  def as_json
    {
      id: tag.id,
      name: tag.name
    }
  end

  private

  attr_reader :tag
end
