#include <ncurses.h>
#define BUFFSIZE 100
#include <locale.h>
#include <stdlib.h>


#include "mruby.h"
#include "mruby/proc.h"
#include "mruby/compile.h"
#include "mruby/string.h"

void redisplay(mrb_state *mrb, mrb_value buffer);
void evaluate(mrb_state *mrb, mrb_value command, mrb_value key, mrb_value buffer);

int main() {
    char buf[BUFFSIZE];
    int key;

    //日本語
    setlocale(LC_ALL,"");
    // curses初期化
    initscr();
    cbreak();
    noecho();

    //TRUEだと特殊生ーを押した時にキーコードを返す。FALSEだとエスケープシーケンス
    //keypad(stdscr, TRUE);

    mrb_state *mrb = mrb_open();
    // mrubyファイルをロードする
    FILE *f = fopen("mruby/init.rb", "r");
    //mrb_load_irep_file(mrb, f);
    mrb_load_file(mrb, f);

    // クラスオブジェクトを取得する
    struct RClass *caller = mrb_class_get(mrb, "Init");

    // 引数をmrb_valueに変換する
    mrb_value caller_value = mrb_obj_value(caller);

    // Init#newを呼び出す
    mrb_value call = mrb_funcall(mrb, caller_value, "new", 0);

    struct RClass *buffer = mrb_class_get(mrb, "Buffer");
    mrb_value buffer_instance = mrb_funcall(mrb, mrb_obj_value(buffer), "new", 0);

    struct RClass *command = mrb_class_get(mrb, "Command");
    mrb_value command_instance = mrb_funcall(mrb, mrb_obj_value(command), "new", 0);
        
    while(1){
        key = getch();
        mrb_value input_key = mrb_fixnum_value(key);
        evaluate(mrb, command_instance, input_key, buffer_instance);
        redisplay(mrb, buffer_instance);
    }

    endwin();

    mrb_close(mrb);

    return 0;
}

void redisplay(mrb_state *mrb, mrb_value buffer){
    clear();
    mrb_value buffer_output = mrb_funcall(mrb, buffer, "get_buffer", 0);
    const char *body = mrb_string_value_ptr(mrb, buffer_output);
    addstr(body);
}

void evaluate(mrb_state *mrb, mrb_value command, mrb_value key, mrb_value buffer){
    mrb_funcall(mrb, command, "evaluate", 2, key, buffer);
}
