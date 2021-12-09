require 'rails_helper'

describe TagRepresenter do
  let(:name) { 'Thai food' }
  let(:tag) { create(:tag, name: name) }
  describe 'as_json' do
    subject { TagRepresenter.new(tag).as_json }
    it 'returns the correct hash' do
      expect(subject).to eq({
        id: tag.id,
        name: name
      })
    end
  end
end
