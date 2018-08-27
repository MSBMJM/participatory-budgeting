class Admin::ClassifierController < AdminController
  before_action :set_classifier, only: [:show, :edit, :update, :destroy]


  def index
    @classifiers = Classifier.all.order(updated_at: :desc)
  end

  def show
  end

  def new
    @classifier = Classifier.new
  end

  def edit
  end

  def create
    @classifier = Classifier.new(classifier_params)
    if @classifier.save
      redirect_to admin_classifier_index_path, success: _('classifier was successfully created.')
    else
      flash.now[:error] = @classifier.errors.full_messages.to_sentence
      render :new
    end
  end

  def update

    if @classifier.update(classifier_params)
      redirect_to admin_classifier_index_path, success: _('classifier was successfully updated.')
    else
      flash.now[:error] = @classifier.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @classifier.destroy
    redirect_to admin_classifier_index_path, success: _('classifier was successfully deleted.')
  end

  def set_classifier
    @classifier = Classifier.find(params[:id] ? params[:id] : params[:format])
  end

  def classifier_params
    if params[:classifier]
      p = params.require(:classifier).permit(:name, :type, :active, :budget, :start_date, :end_date)
    elsif params[:area]
      p = params.require(:area).permit(:name, :type, :active, :budget, :start_date, :end_date)
    elsif params[:tag]
      p = params.require(:tag).permit(:name, :type, :active, :budget, :start_date, :end_date)
    elsif params[:district]
      p = params.require(:district).permit(:name, :type, :active, :budget, :start_date, :end_date)
    end
    # p[:budget] = p[:budget]&.gsub(',', '_')&.to_d if p[:budget]
    # p[:image] = nil if params[:delete_image]
    p
  end
end