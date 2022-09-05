import { ShowToastEvent } from 'lightning/platformShowToastEvent';
function showAlert(component, title, variant) {
    component.dispatchEvent(new ShowToastEvent({ title, variant }));
}
async function handlePromise(component, promise, _params) {
    try {
        return (await promise(_params));
    } catch (error) {
        showAlert(component, 'Unhandled error', 'error');
        console.error(error);
    }
}
export { showAlert, handlePromise };