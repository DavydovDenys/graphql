# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @user = User.new
  end

  def show
    @user     = User.find(params[:id])
    @projects = Project.includes(:user)
  end

  def create
    @user = User.new(github_name_params)
    if @user.save
      github_repos_params.each do |params|
        @user.projects.create(params)
      end
      redirect_to @user
    else
      render :new
    end
  end

  private

  def github_repos_params
    GithubService.new(login_params[:name]).repos
  end

  def github_name_params
    GithubService.new(login_params[:name]).name
  end

  def login_params
    params.require(:user).permit(:name)
  end
end
