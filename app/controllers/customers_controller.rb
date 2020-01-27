class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.all
    respond_to do |format|
      format.html
      format.pdf do
        pdf = CustomerPdf.new(@customers)
        send_data pdf.render, filename: "customers.pdf",type: "application/pdf",disposition: "inline"
      end
    end
  end
def export
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="report.xls"'
    headers['Cache-Control'] = ''
    @customers = Customer.all
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def search
    products = find_product(params[:products])
    unless products
      flash[:alert] = 'Producty not found'
      return render action: :index
    end
    @product = products.first
    @user= find_user(@product['Juice'], @product['Mango'])
  end
  def find_user(email, password)
    query = URI.encode("#{email},#{password}")
    request_api(
      "http://dev.mobivat.com:8080/vsdc_module/mobivat/api/product/productId?upc=224444445#{query}"
    )
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:names, :email, :contact, :user_id)
    end
    def request_api(url)
      response = Excon.get(
        url,
        headers: {
          'X-RapidAPI-Host' => URI.parse(url).host,
          'X-RapidAPI-Key' => ENV.fetch('RAPIDAPI_API_KEY')
        }
      )
      return nil if response.status != 200
      JSON.parse(response.body)
    end
    def find_product(pname)
      request_api(
        "http://dev.mobivat.com:8080/vsdc_module/mobivat/api/product/productId?upc=224444445#{URI.encode(pname)}"
      )
    end
  end
