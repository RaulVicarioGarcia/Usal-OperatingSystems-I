#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <unistd.h>
#include <signal.h>
//# include <bits/sigaction.h>
#include <fcntl.h>


typedef struct InfoCell{
    int idNumber;
    pid_t pidProcess;
}InfoCell;

void childExecution(int idNumber);
int createChildrens(int idNumber);
void addInfoCellToMap(int idNumber, pid_t pidProcess);
InfoCell* createMap();
void closingProgram();
void manejadoraSigusr1(int sign);
void manejadoraAlarma(int sign);


pid_t childPid1;
pid_t childPid2;
InfoCell *map;
int file;
const char *filename = "info_cells.bin";

int main(){

    int idNumber = 37;
    struct sigaction sa;
    sa.sa_handler = manejadoraSigusr1;
    sa.sa_flags = 0; // No flags
    sigemptyset(&sa.sa_mask);

    if (sigaction(SIGUSR1, &sa, NULL) == -1) {
        perror("sigaction");
        exit(EXIT_FAILURE);
    }

    struct sigaction sa_alrm;
    sa_alrm.sa_handler = manejadoraAlarma;
    sa_alrm.sa_flags = 0;
    sigemptyset(&sa_alrm.sa_mask);

    if (sigaction(SIGALRM, &sa_alrm, NULL) == -1) {
        perror("sigaction");
        exit(EXIT_FAILURE);
    }
    map = createMap();
    
    switch(childPid1 = fork()){
        case -1:
            //Error
            break;
        case 0:
            //Proceso hijo
            createChildrens(idNumber+1); //Crea a los hijos
            childExecution(idNumber+1);
            //Espera a la señal
            break;
        default:
        //Proceso padre
            childPid2 = -1;
            printf("Soy el proceso padre padre %d con pid: %d\n", idNumber, getpid());
            alarm(4);
            for(;;){
                pause();
            }
            break;
    }
    
    return 0;
}


void createSideChildrens(int idChildNumber){
    printf("Soy el Sideproceso %d con pid: %d\n", idChildNumber, getpid());
    switch (idChildNumber)
    {
    case 50:
    switch (childPid1 = fork())
        {
        case -1:
            break;
        case 0:
            createSideChildrens(idChildNumber + 4);
            childExecution(idChildNumber+4);
            break;
        default:
            childPid2 = -1;
            break;
        }
        break;
    case 52:
    switch (childPid1 = fork())
        {
        case -1:
            break;
        case 0:
            createChildrens(idChildNumber + 3);
            childExecution(idChildNumber+3);
            break;
        default:
            childPid2 = -1;
            break;
        }
        break;
    case 54:
        addInfoCellToMap(54, getpid());
        switch (childPid1 = fork())
        {
        case -1:
            break;
        case 0:
            createChildrens(idChildNumber + 2);
            childExecution(idChildNumber+2);
            break;
        default:
            childPid2 = -1;
            break;
        }
        break;
    case 51:
        childExecution(idChildNumber);
        childPid2 = -1;
        break;
    case 53:
        childExecution(idChildNumber);
        childPid2 = -1;
        break;
    default:
        switch (childPid1 = fork())
        {
        case -1:
            break;
        case 0:
            createSideChildrens(idChildNumber+4);
            childExecution(idChildNumber+4);
            break;
        default:
            childPid2 = -1;
            break;
        }
        break;
    }
}

int createChildrens(int idNumber){

    printf("Soy el proceso %d con pid: %d\n", idNumber, getpid());
    if(idNumber == 39){
        switch (childPid1 = fork())
        {
        case -1:
            break;
        case 0:
            createChildrens(idNumber+1);
            childExecution(idNumber);
            break;
        default:
            switch (childPid2 = fork())
            {
            case -1:
                break;
            case 0:
                createChildrens(idNumber+2);
                childExecution(idNumber);
                break;
            default:
                break;
            }
            break;
        }
    }else
    if(idNumber == 40){
        switch (childPid1 = fork())
        {
        case -1:
            break;
        case 0:
            createSideChildrens(idNumber+2);
            childExecution(idNumber+2);
            break;
        default:
            switch (childPid2 = fork())
            {
            case -1:
                break;
            case 0:
                createSideChildrens(idNumber+3);
                childExecution(idNumber+3);
                break;
            default:
                break;
            }
            break;
        }
    }else if(idNumber == 41){
        switch (childPid1 = fork())
        {
        case -1:
            break;
        case 0:
            createSideChildrens(idNumber+3);
            childExecution(idNumber+3);
            break;
        default:
            switch (childPid2 = fork())
            {
            case -1:
                break;
            case 0:
                createSideChildrens(idNumber+4);
                childExecution(idNumber+4);
                break;
            default:
                break;
            }
            break;
        }
    }else if(idNumber == 55){
        addInfoCellToMap(idNumber, getpid());
        childPid2 = -1;
    }else if(idNumber == 56){
        addInfoCellToMap(idNumber, getpid());
        switch (childPid1 = fork())
        {
        case -1:
            break;
        case 0:
            createChildrens(idNumber+1);
            childExecution(idNumber+1);
            break;
        default:
            childPid2 = -1;
            break;
        }
    }else if(idNumber == 58){
        childPid1 = -1;
        childPid2 = -1;
    }else{
        switch (childPid1 = fork())
        {
        case -1:
            break;
        case 0:
            createChildrens(idNumber+1);
            childExecution(idNumber+1);
            break;
        default:
            childPid2 = -1;
            break;
        }
    }
    
}

void addInfoCellToMap(int idNumber, pid_t pidProcess){
    InfoCell infoCell;
    infoCell.idNumber = idNumber;
    infoCell.pidProcess = pidProcess;

    switch (idNumber)
    {
    case 54:
        map[0] = infoCell;
        break;
    case 55:
        map[1] = infoCell;
        break;
    case 56:
        map[2] = infoCell;
        break;
    }
}

InfoCell* createMap(){
    file = open(filename, O_RDWR | O_CREAT | O_TRUNC, 0600);
    if (file == -1) {
        perror("open");
        exit(EXIT_FAILURE);
    }
    if (ftruncate(file, 3*sizeof(InfoCell)) == -1) {
        perror("ftruncate");
        close(file);
        exit(EXIT_FAILURE);
    }

    InfoCell *map = (InfoCell*)mmap(0, 3*sizeof(InfoCell), PROT_READ | PROT_WRITE, MAP_SHARED, file, 0);

    if(map == MAP_FAILED){
        printf("Error en creacion de mapa\n");
        perror("mmap");
        close(file);
        exit(EXIT_FAILURE);
    }else{
        int i;
        for(i = 0; i < 3; i++){
            map[i].idNumber = -1;
            map[i].pidProcess = -1;
        }
    }
    return map;
}

void closingProgram(){
    munmap((void*)map, 3*sizeof(InfoCell));
    close(file);
    remove(filename);
    exit(0);
}

void childExecution(int idNumber){
    if(idNumber == 51){
        while(map[0].idNumber == -1){
        }
        childPid1 = map[0].pidProcess;
    }else if(idNumber == 53){
        while(map[1].idNumber == -1){
        }
        childPid1 = map[1].pidProcess;
    }else if(idNumber == 55){
        while(map[2].idNumber == -1){
        }
        childPid1 = map[2].pidProcess;
    }else if(idNumber == 50){
        childPid1 = -1;
    }else if(idNumber == 52){
        childPid1 = -1;
    }else if(idNumber == 54){
        childPid1 = -1;
    }
    for(;;){
        pause();
    }
}

void manejadoraSigusr1(int sign){
    if(childPid1 != -1){
        //Manda señal al hijo 1
        if (kill(childPid1, SIGUSR1) == -1) {
            perror("Error al enviar la señal");
            exit(EXIT_FAILURE);
        }

    }
    if(childPid2 != -1){
        //Manda señal al hijo 2
        if (kill(childPid2, SIGUSR1) == -1) {
            perror("Error al enviar la señal");
            exit(EXIT_FAILURE);
        }
    }
    printf("Soy el proceso con pid: %d y voy a morir\n", getpid());
    exit(0);
}

void manejadoraAlarma(int sign){
    if (kill(childPid1, SIGUSR1) == -1) {
        perror("Error al enviar la señal");
        exit(EXIT_FAILURE);
    }
    closingProgram();
}
