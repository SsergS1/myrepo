package knit.semit.psr.marketplace.enums;

public enum MsgForUser {


    OK_UPD_MSG  ("USER update -- SUCCESS!"),
    OK_DEL_MSG  ("USER delete -- SUCCESS!"),
    ERR_INS_MSG ("USER insert -- ERROR!"),
    ERR_UPD_MSG ("USER update -- ERROR!"),

    ERR_NOT_IN_MSG ("USER -- USER not found in DB!"),

    ERR_DOUBLE_MSG ("USER -- USER already present in DB!"),

    ERR_ID_NULL_MSG ("USER -- USER id is null!");


    private String text;

    MsgForUser(String s) {
        text = s;
    }

    public String getText() {
        return text;
    }

    public static MsgForUser getMessageByText(String text) {
        int index = -1;
        MsgForUser[] messagesValues = values();
        boolean flFound = false;
        while (!flFound && index<messagesValues.length-1) {
            index++;
            if (messagesValues[index].getText().equals(text)) {
                flFound = true;
            }
        }
        MsgForUser msg = null;
        if (!flFound) {
            msg = null;
        } else {
            msg = MsgForUser.values()[index];
        }
        return msg;
    }

}
