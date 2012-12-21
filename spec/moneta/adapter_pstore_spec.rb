# Generated by generate.rb
require 'helper'

describe_moneta "adapter_pstore" do
  def new_store
    Moneta::Adapters::PStore.new(:file => File.join(make_tempdir, "adapter_pstore"))
  end

  def load_value(value)
    Marshal.load(value)
  end

  include_context 'setup_store'
  it_should_behave_like 'null_stringkey_stringvalue'
  it_should_behave_like 'store_stringkey_stringvalue'
  it_should_behave_like 'returndifferent_stringkey_stringvalue'
  it_should_behave_like 'increment'
  it_should_behave_like 'null_stringkey_objectvalue'
  it_should_behave_like 'store_stringkey_objectvalue'
  it_should_behave_like 'returndifferent_stringkey_objectvalue'
end
