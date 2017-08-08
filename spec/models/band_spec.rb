require 'spec_helper'

describe Band do

# Это создается "виктуальная" новость, с которой ниже выполняются тесты;
  before { @band = Band.new(bn_head: "GLOBAL MARKETS", novelty: "European stock markets open down", 
  bn_date: "2017-07-14 19:57:39", bn_url: "http://www.reuters.com/article/global-markets-idUSL5N1KP1QZ") }

  subject { @band }	# это указывает, что объектом тестирования будет указанная выше запись

# каждый it проверяет НАЛИЧИЕ соотв.поля
  it { should respond_to(:bn_head) }
  it { should respond_to(:novelty) }
  it { should respond_to(:bn_date) }
  it { should respond_to(:bn_url) }

  it { should be_valid }	# здесь проверяется - валидна ли созданная для проверки запись

# БЛОК 1 здесь проверяется каждое поле по очереди, что если оно пустое, то это не валидно. Т.е, тогда 'should_not be_valid' возвращает  'true';
  describe "when head is not present" do
    before { @band.bn_head = " " }
    it { should_not be_valid }
  end

  describe "when novelty is not present" do
    before { @band.novelty = " " }
    it { should_not be_valid }
  end

  describe "when bn_date is not present" do
    before { @band.bn_date = " " }
    it { should_not be_valid }
  end

  describe "when bn_url is not present" do
    before { @band.bn_url = " " }
    it { should_not be_valid }
  end
## конец БЛОК 1
# Листинг 6.15. Тест на отклонение повторяющихся ... у меня - URL
describe "when URL is already taken" do
    before do
      band_with_same_bn_url = @band.dup	# user_with_same_email = @user.dup
      band_with_same_bn_url.save		# user_with_same_email.save
    end

    it { should_not be_valid }
  end
## конец # Листинг 6.15.
end
