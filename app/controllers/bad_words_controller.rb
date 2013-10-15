class BadWordsController < ApplicationController
  helper :layout
	layout  "bad_words"
	
  def index_case
    @title = "案例标题"
    @key = DECO_CASE_NAME_BAD_WORDS_KEY
    share
    
  end
  
  def index
    @key = BAD_WORDS_KEY
    @title = "全局"
    share
  end
  
  def filter
    
  end
  
  def share
    per_page = 10
    search_word = params[:bad_word]
    @page = params[:page] ? params[:page].to_i : 1
    if search_word.nil?
      @bad_words = BadWord.all(@key)[(@page-1)*per_page , per_page]
    else
      @bad_words = BadWord.find(@key , search_word)
    end
    @page_count = (BadWord.all(@key).nil? ? 1 : BadWord.all(@key).size) / per_page + 1
  end
    
  def case_name_search
    @cases = DecoCase.find(:all,:select=>"ID,NAME",:conditions=>"CREATEDATE > '2009-1-1' and STATUS <> '-100' and name like '%#{params[:keyword]}%'")
  end

  def create
    bad_key = params[:key]
    params[:bad_word].split("\r").each_with_index do |bad_word,i|
      BadWord.create(bad_key , bad_word.strip)
    end
    redirect_back
  end


  def destroy
    bad_key = params[:key]
    bad_words = params[:bad_word]
    bad_words.each do |bad_word|
      BadWord.destroy(bad_key , bad_word.strip)
    end
    redirect_back
  end
end
