require 'spec_helper'
require_relative '../log_parser.rb'

RSpec.describe LogParser do
  describe '.order_logs' do
    subject(:order_logs) { log_parser.order_logs }

    let(:log_parser) { described_class.new(path) }
    let(:enumerator_dummy) do
      [
        '/help_page/1 126.318.035.038',
        '/contact 184.123.665.067',
        '/home 184.123.665.067',
        '/about/2 444.701.448.104',
        '/help_page/1 929.398.951.889',
        '/index 444.701.448.104',
        '/help_page/1 722.247.931.582',
        '/about 061.945.150.735',
        '/help_page/1 646.865.545.408',
        '/home 235.313.352.950',
        '/contact 184.123.665.067',
        '/help_page/1 543.910.244.929',
        '/home 316.433.849.805',
        '/about/2 444.701.448.104',
        '/contact 543.910.244.929',
        '/about 126.318.035.038'
      ].each
    end

    describe 'when everything goes well' do
      let(:path) { 'test_path.log' }
      let(:result) do
        [
          'Most page views:',
          '/help_page/1 5 visits',
          '/home 3 visits',
          '/contact 3 visits',
          '/about 2 visits',
          '/about/2 2 visits',
          '/index 1 visits',
          'Unique page views:',
          '/help_page/1 5 unique views',
          '/home 3 unique views',
          '/about 2 unique views',
          '/contact 2 unique views',
          '/index 1 unique views',
          '/about/2 1 unique views'
        ]
      end

      before do
        allow(IO).to receive(:foreach).and_return(enumerator_dummy)
      end

      it 'returns ordered array with logs' do
        expect(order_logs).to eq(result)
      end
    end

    describe "when given file doesn't exists" do
      let(:path) { 'test_path.log' }
      let(:error) { "File #{path} not found" }

      it 'returns error' do
        expect(order_logs).to eq(error)
      end
    end

    describe 'when given file has wrong extension' do
      let(:path) { 'test_path.jpg' }
      let(:error) { 'Given file is not a log file' }

      it 'returns error' do
        expect(order_logs).to eq(error)
      end
    end
  end
end
