class MagentosController < ApplicationController

  load_and_authorize_resource

  before_action :find_magento_by_id, only: [:edit, :update, :destroy]
  before_action :find_magento_by_magento_id, only: [:update_specific_version]

  def new
    @magento = Magento.new
  end

  def create
    @magento = Magento.new(magento_params)
    if @magento.save
      flash.keep[:success] = "Magento criado com sucesso."
      redirect_to platforms_path
    else
      flash.now[:error] = "Não foi possível criar o Magento."
      render :new
    end
  end

  def edit
  end

  def update
    if @magento.update_attributes(magento_params)
      flash.keep[:info] = "[#{@magento.name.capitalize}] Editado com sucesso."
      redirect_to platforms_path
    else
      flash.now[:error] = "Não foi possível salvar as modificações."
      render :edit
    end
  end

  def destroy
    if @magento.destroy
      flash.keep[:success] = "Magento removido com sucesso."
    else
      flash.keep[:error] = "Não foi possível remover o magento."
    end
    redirect_to platforms_path
  end

  def update_specific_version
    respond_to do |format|
      begin
        @magento.specific_version = @magento.get_specific_version
        if @magento.save
          format.json { render json: { specific_version: @magento.specific_version }, status: 200 }
        else
          format.json { render json: @magento.errors.full_messages, status: :unprocessable_entity }
        end
      rescue Exception => e
        format.json { render json: e.message, status: :internal_server_error }
      end
    end
  end

  private

  def find_magento_by_id; @magento = Magento.find(params[:id]) end

  def find_magento_by_magento_id; @magento = Magento.find(params[:magento_id]) end

  def magento_params; params.require(:magento).permit(:name, :url, :version, :api_user, :api_key, :api_url, :start_date ) end

end
