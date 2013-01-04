shared_examples_for 'a sidekiq worker' do
  it { should respond_to :perform_async }
  its(:included_modules) { should include Sidekiq::Worker }
end