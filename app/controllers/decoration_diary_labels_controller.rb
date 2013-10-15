class DecorationDiaryLabelsController < ApplicationController
  helper :layout
  layout  "decoration_diary_labels"
  
  def show
    
  end
  
  def edit
    @diary = DecorationDiary.find(params[:id])
  end
  
  def update
    @diary = DecorationDiary.find(params[:id])
    if params[:diary].nil?
      @diary.update_attribute(:tags, nil)
    else
      @diary.update_attribute(:tags, params[:diary][:tags])
    end
    flash[:notice] = "修改成功"
    redirect_to edit_decoration_diary_label_path(@diary)
  end
  
end