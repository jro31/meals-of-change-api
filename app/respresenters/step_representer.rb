class StepRepresenter
  def initialize(step)
    @step = step
  end

  def as_json
    {
      position: step.position,
      instructions: step.instructions
    }
  end

  private

  attr_reader :step
end
