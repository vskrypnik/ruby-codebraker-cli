require 'spec_helper'

RSpec.describe Application do
  context 'playing' do
    before do
      @game = subject.instance_variable_get :@game
      @code = @game.instance_variable_set :@code, '1234'
      @hint = @game.instance_variable_set :@hint, '3'
    end

    after(:all) do
      if File.exist? 'score.yaml'
        File.delete 'score.yaml'
      end
    end

    describe 'invalid input' do
      before(:all) do
        @message = 'invalid input'
        @regexp = Regexp.new @message
      end

      ['', 'abc', '1ab', 'ab2'].each do |input|
        it 'should output message about invalid input data' do
          allow(Output).to receive(:help).and_return @message
          allow(subject).to receive(:gets).and_return(input, '1234')
          expect { subject.send :play }.to output(@regexp).to_stdout
        end
      end
    end

    describe 'losing the game' do
      before(:all) do
        @message = 'So sorry... You lose.'
        @regexp = Regexp.new @message
      end

      it 'should output message about fail' do
        allow(subject).to receive(:gets).and_return(*['4321'] * 5)
        expect { subject.send :play }.to output(@regexp).to_stdout
      end
    end

    describe 'winning the game' do
      before(:all) do
        @message = 'Congratulations! You win!'
        @regexp = Regexp.new @message
      end

      it 'should output message about fail' do
        allow(subject).to receive(:gets).and_return(*['1234'] * 5)
        expect { subject.send :play }.to output(@regexp).to_stdout
      end
    end

    describe 'requesting hint' do
      it 'should output message with hint' do
        message = "The number contains digit: #{@hint}."
        regexp = Regexp.new message

        allow(subject).to receive(:gets).and_return('hint', '1234')
        expect { subject.send :play }.to output(regexp).to_stdout
      end

      it 'should output message with text that there is no available hints' do
        message = 'All available hints have already been used!'
        regexp = Regexp.new message

        allow(subject).to receive(:gets).and_return('hint', 'hint', '1234')
        expect { subject.send :play }.to output(regexp).to_stdout
      end
    end

    describe 'save score request' do
      it 'should ask after the code was breaked' do
        message = 'Do you want to save the score?'
        regexp = Regexp.new message

        allow(subject).to receive(:gets).and_return('1234', 'y', 'nickname')
        expect { subject.run }.to output(regexp).to_stdout
      end

      it 'should ask after the code was not breaked' do
        message = 'Do you want to save the score?'
        regexp = Regexp.new message

        allow(subject).to receive(:gets).and_return(*['4321'] * 5, 'y', 'nickname')
        expect { subject.run }.to output(regexp).to_stdout
      end
    end

    describe 'play again request' do
      it 'should ask after the code was breaked' do
        message = 'Do you want to play again?'
        regexp = Regexp.new message

        allow(subject).to receive(:gets).and_return('1234', 'y', 'nickname')
        expect { subject.run }.to output(regexp).to_stdout
      end
    end
  end
end
