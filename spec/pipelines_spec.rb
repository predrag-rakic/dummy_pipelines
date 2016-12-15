require 'spec_helper'

describe Pipelines do
  it 'has a version number' do
    expect(Pipelines::VERSION).not_to be nil
  end

  it 'creates Exec object' do
    actions = [{"cmd" => []}, {"test" => []}]
    e = Pipelines::Exec.new(actions, "foo")
    expect(e).not_to be nil
    expect(e.cmd).to eq([])
  end
end
