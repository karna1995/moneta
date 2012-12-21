# Generated by generate.rb
require 'helper'

describe_moneta "adapter_file" do
  def new_store
    Moneta::Adapters::File.new(:dir => File.join(make_tempdir, "adapter_file"))
  end

  def load_value(value)
    Marshal.load(value)
  end

  include_context 'setup_store'
  it_should_behave_like 'null_stringkey_stringvalue'
  it_should_behave_like 'store_stringkey_stringvalue'
  it_should_behave_like 'returndifferent_stringkey_stringvalue'
  it_should_behave_like 'not_increment'
end
