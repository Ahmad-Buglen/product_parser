# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  subject do
    described_class.new(price_list: 'asdfg.csv',
                        brand: 'qwerty',
                        code: '44881-2C',
                        stock: 1,
                        cost: 0.45e4,
                        name: 'Пневморессора')
  end
  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end
  it 'is valid without a name' do
    subject.name = nil
    expect(subject).to be_valid
  end
  it 'is not valid without a brand' do
    subject.brand = nil
    expect(subject).to_not be_valid
  end
  it 'is not valid without a price_list' do
    subject.price_list = nil
    expect(subject).to_not be_valid
  end
  it 'is not valid without a code' do
    subject.code = nil
    expect(subject).to_not be_valid
  end
  it 'is not valid without a cost' do
    subject.cost = nil
    expect(subject).to_not be_valid
  end
  # pending "add some examples to (or delete) #{__FILE__}"
end
