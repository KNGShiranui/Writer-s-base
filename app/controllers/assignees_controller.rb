class AssigneesController < ApplicationController
  before_action :set_assignee, only: %i(show edit update destroy)

  # GET /assignees or /assignees.json
  def index
    @assignees = Assignee.all
  end

  # GET /assignees/1 or /assignees/1.json
  def show
  end

  # GET /assignees/new
  def new
    @assignee = Assignee.new
  end

  # GET /assignees/1/edit
  def edit
  end

  # POST /assignees or /assignees.json
  def create
    @assignee = Assignee.new(assignee_params)

    respond_to do |format|
      if @assignee.save
        format.html { redirect_to assignee_url(@assignee), notice: "Assignee was successfully created." }
        format.json { render :show, status: :created, location: @assignee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @assignee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignees/1 or /assignees/1.json
  def update
    respond_to do |format|
      if @assignee.update(assignee_params)
        format.html { redirect_to assignee_url(@assignee), notice: "Assignee was successfully updated." }
        format.json { render :show, status: :ok, location: @assignee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @assignee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignees/1 or /assignees/1.json
  def destroy
    @assignee.destroy

    respond_to do |format|
      format.html { redirect_to assignees_url, notice: "Assignee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignee
      @assignee = Assignee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def assignee_params
      params.require(:assignee).permit(:user_id, :issue_id)
    end
end
