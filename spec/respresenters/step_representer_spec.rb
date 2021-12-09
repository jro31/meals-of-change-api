require 'rails_helper'

describe StepRepresenter do
  let(:position) { 3 }
  let(:instructions) { 'Cook the food' }
  let(:step) { create(:step, position: position, instructions: instructions) }
  describe 'as_json' do
    subject { StepRepresenter.new(step).as_json }
    it 'returns the correct hash' do
      expect(subject).to eq({
        position: position,
        instructions: instructions
      })
    end
  end
end
