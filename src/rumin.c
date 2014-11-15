#include <ncurses.h>
#include <locale.h>
#include <stdlib.h>
#include <dlfcn.h>
#define BUFFSIZE 100

#include "mruby.h"
#include "mruby/proc.h"
#include "mruby/compile.h"
#include "mruby/string.h"
#include "mruby/array.h"

void input_key(mrb_state *mrb, mrb_value keys);
void evaluate(mrb_state *mrb, mrb_value command, mrb_value keys, mrb_value buffer);
void redisplay(mrb_state *mrb, mrb_value buffer);

int main() {
    char buf[BUFFSIZE];

    //日本語
    setlocale(LC_ALL,"");
    // curses初期化
    initscr();
    cbreak();
    noecho();

    //TRUEだと特殊生ーを押した時にキーコードを返す。FALSEだとエスケープシーケンス
    //keypad(stdscr, TRUE);

    mrb_state *mrb = mrb_open();

    // Ruminインスタンスの作成
    // mrubyファイルのロード
    FILE *f1 = fopen("mruby/rumin.rb", "r");
    // mrb_load_irep_file(mrb, f1);
    mrb_load_file(mrb, f1);
    // クラスオブジェクトを取得する
    struct RClass *rumin = mrb_class_get(mrb, "Rumin");
    // 引数をmrb_valueに変換する
    mrb_value rumin_value = mrb_obj_value(rumin);
    // Rumin#newを呼び出す
    mrb_value rumin_instance = mrb_funcall(mrb, rumin_value, "new", 0);
    // Editorインスタンスの取得
    mrb_value editor_instance = mrb_funcall(mrb, rumin_instance, "editor", 0);
    // Bufferインスタンスの取得
    mrb_value buffer_instance = mrb_funcall(mrb, editor_instance, "current_buffer", 0);

    // Commandインスタンスの初期化
    FILE *f3 = fopen("mruby/command.rb", "r");
    mrb_load_file(mrb, f3);
    struct RClass *command = mrb_class_get(mrb, "Command");
    mrb_value command_value = mrb_obj_value(command);
    mrb_value command_instance = mrb_funcall(mrb, command_value, "new", 0);

    mrb_value keys = mrb_ary_new(mrb);
    while(1) {
        input_key(mrb, keys);
        evaluate(mrb, command_instance, keys, buffer_instance);
        redisplay(mrb, buffer_instance);
    }

    endwin();

    mrb_close(mrb);

    return 0;
}

void input_key(mrb_state *mrb, mrb_value keys){
    int key;
    key = getch();
    mrb_ary_clear(mrb, keys);
    mrb_ary_push(mrb, keys, mrb_fixnum_value(key));
    if(key == 27) {
        // arrow key
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
    } else if(key >= 192 && key <= 223) {
        // 2 bytes
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
    } else if(key >= 224 && key <= 239) {
        // 3 bytes
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
    } else if(key >= 240 && key <= 255) {
        // 4 bytes
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
        mrb_ary_push(mrb, keys, mrb_fixnum_value(getch()));
    }
}

void evaluate(mrb_state *mrb, mrb_value command, mrb_value keys, mrb_value buffer){
    mrb_funcall(mrb, command, "evaluate", 2, keys, buffer);
}

void redisplay(mrb_state *mrb, mrb_value buffer){
    clear();
    mrb_value buffer_output = mrb_funcall(mrb, buffer, "get_content", 0);
    const char *body = mrb_string_value_ptr(mrb, buffer_output);
    addstr(body);
    mrb_value row = mrb_funcall(mrb, buffer, "get_cursor_row", 0);
    mrb_value col = mrb_funcall(mrb, buffer, "get_cursor_col", 0);
    move(mrb_fixnum(row), mrb_fixnum(col));
}
