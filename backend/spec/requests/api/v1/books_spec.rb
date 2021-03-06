# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::BooksController', type: :request do
  let(:user)       { FactoryBot.create(:user) }
  let(:book)       { FactoryBot.create(:book) }
  let(:params) do
    { book: { title: 'ブックタイトル', isbn: '23456789098765' },
      registration: nil }
  end
  let(:params_registration) do
    { book: { title: 'ブックタイトル', isbn: '12345678909876' },
      registration: true }
  end

  it '本の詳細ページを返す' do
    # 楽天apiを利用するためisbnを指定
    book = Book.create(title: 'ブックタイトル', isbn: '9784797395846')
    log_in_as(user)
    # ユーザーと登録本を紐付ける
    user.subscriptions.create(book_id: book.id)
    get "/api/v1/books/#{book.isbn}"
    expect(response.status).to eq(200)
    expect(json['registration']).to be_truthy
    expect(json['subscribed']).to be_truthy
  end

  it '未ログインユーザーは本の詳細ページを返せない' do
    user.subscriptions.create(book_id: book.id)
    get "/api/v1/books/#{book.isbn}"
    expect(response.status).to eq(401)
  end

  it '新しい本を登録する(DBへ初めての登録ケース)' do
    log_in_as(user)
    expect { post api_v1_books_path, params: params }.to change(Book, :count).by(1)
    expect(response.status).to eq(201)
  end

  it '新しい本を登録する(DBへすでに登録済みのケース)' do
    Book.create(title: 'ブックタイトル', isbn: '12345678909876')
    log_in_as(user)
    expect { post api_v1_books_path, params: params_registration }.to change(Book, :count).by(0)
    expect(response.status).to eq(201)
  end

  it '未ログインユーザーは新しい本を登録できない' do
    post api_v1_books_path, params: params
    expect(response.status).to eq(401)
  end

  it '読了/積読情報の更新をする' do
    log_in_as(user)
    user.subscriptions.create(book_id: book.id, read: false)
    patch "/api/v1/books/#{book.isbn}", params: { read: true }
    expect(json['subscription']['read']).to be_truthy
    expect(response.status).to eq(200)
  end

  it '未ログインユーザーは読了/積読情報の更新できない' do
    user.subscriptions.create(book_id: book.id, read: false)
    patch "/api/v1/books/#{book.isbn}", params: { read: true }
    expect(response.status).to eq(401)
  end
end
