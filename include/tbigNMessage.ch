#ifndef _pt_TBigNMessage_CH

    #define _pt_TBigNMessage_CH

    #ifdef __ADVPL__
        #define MSG_CONOUT      1//:Mensagem via ConOut
        #define MSG_ALERT       2//:Mensagem via MsgAlert
        #define MSG_INFO        3//:Mensagem via MsgInfo
        #define MSG_STOP        4//:Mensagem via MsgStop
        #define MSG_INTERNAL    5//:Mensagem via PTInternal
        #define MSG_HELP        6//:Mensagem via Help
        #define MSG_LOG         7//:Mensagem via LOG
    #else //__HARBOUR__
    #endif //__ADVPL__

#endif /*_pt_TBigNMessage_CH*/
