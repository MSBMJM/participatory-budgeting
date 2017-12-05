class Admin::ConstituencyController < AdminController
  before_action :set_constituency, only: [:show, :edit, :update, :destroy]


  def index
    @constituencies = Constituency.all.order(updated_at: :desc)
  end

  def show
  end

  def new
    @constituency = Constituency.new
  end

  def edit
  end

  def create
    @constituency = Constituency.new(constituency_params)
    if @constituency.save
      redirect_to admin_constituency_index_path, success: _('constituency was successfully created.')
    else
      flash.now[:error] = @constituency.errors.full_messages.to_sentence
      render :new
    end
  end

  def update

    if @constituency.update(constituency_params)
      redirect_to admin_constituency_index_path, success: _('constituency was successfully updated.')
    else
      flash.now[:error] = @constituency.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @constituency.destroy
    redirect_to admin_constituency_index_path, success: _('constituency was successfully destroyed.')
  end

  def set_constituency
    @constituency = Constituency.find(params[:id])
  end

  def constituency_params
    p = params.require(:constituency).permit(:title, :description, :active, :budget, :start_date, :end_date)
    p[:budget] = p[:budget]&.gsub(',', '_')&.to_d if p[:budget]
    # p[:image] = nil if params[:delete_image]
    p
  end
end