class BoardController < ApplicationController
    def pagelogic_write                         #C(R빼고)UD 기능 구현한 함수
      board = params[:board]
      model = Board.where(route: params[:board]).first.articles
      category = params[:category]
      if params[:usage] == "delete"           #Delete Post
        @article = model.find(params[:id])
        @article.active = false
        @article.save
        Uploadfile.destroy_files(params[:id])
        authorize! :destroy, model.last
        redirect_to "/board/#{category}/#{board}"
        return 0
      else                                     #Create Post & Update Post
        @article = model.find(params[:post_id].to_i)
        number = model.find(params[:post_id]).id
        if @article.member_name == nil && @article.active == false
          authorize! :create, @article
        else
          authorize! :update, @article
        end
      end
      @article.title = params[:title]
      @article.content = Loofah.scrub_fragment(params[:content], :escape)
      @article.member_id = current_member.id
      @article.member_name = "#{current_member.senior_number}기 #{current_member.username}"
      @article.active = true
      @article.save
      redirect_to "/board/#{category}/#{board}/#{number}"
    end

    def showBoard
      @category = Category.where(route: params[:category]).take
      @board = @category.boards.where(route: params[:board]).take
      @article = @board.articles.where(active: true)
      authorize! :read, @article.last
      #페이지네이션
      perpage = 10
      if params[:page]
        page = params[:page]
      elsif  params[:id]
        page = ((@article.length - @article.index{|article| article.id == params[:id].to_i} - 1)/perpage).ceil + 1
      else
        page=1
      end
      @article_page = @article.where("title LIKE ?", "%#{params[:search]}%").paginate(:page => page, :per_page => perpage).order('id DESC')
      #Json 요청으로 목록 받아올때
      if params[:json]
        respond_to do |format|
          format.json { render json: make_object_to_json(@article_page) }
        end
      end
      #페이지네이션 끝
      if @board.show_last && @article.last
        if !params[:id]
          params[:id] = @article.last.id
        end
        if current_member
          Statistic.create(name:"read_article", member_id: current_member.id, target_model: Article, target_id: params[:id])
        end
        @thisArticle = @article.find(params[:id])
        render template: "board/showArticle"
      end
      if @board.template && !params[:id]
        if @board.template[0] != '/'
          render template: @board.template
        end
      end
    end
    def showArticle
      showBoard
      Statistic.create(name:"read_article", member_id: current_member.id, target_model: Article, target_id: params[:id])
      @thisArticle = @article.find(params[:id])
    end

    def write_comment
      @article = Article.find(params[:id])
      if @article.board.show_comment
        @comment = Comment.build_from( @article, current_member.id, params[:content] )
        @comment.save
      end
      redirect_to :back
    end

    def delete_comment
      @comment = Comment.find(params[:id])
      authorize! :delete, @comment
      @comment.destroy
      redirect_to :back
    end

    private
    def make_object_to_json(object)
      #AJAX를 위해 view 담기
      @article_page_json = []
      object.each do |value|
        hash = {}
        hash = value.attributes
        hash[:view] = Statistic.where(name: "read_article", target_id: value.id).length
        @article_page_json.push(hash)
      end
      return @article_page_json
    end
end
